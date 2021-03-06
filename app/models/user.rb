class User
  include Mongoid::Document
  include Mongo::Voter
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  ## Database authenticatable
  field :email, type: String, null: false, default: ""
  field :encrypted_password, type: String, null: false, default: ""

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  ## Encryptable
  # field :password_salt,         type: String

  ## Confirmable
  field :confirmation_token, type: String
  field :confirmed_at, type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email, type: String # Only if using reconfirmable

  ## Omniauth
  field :provider, type: String
  field :uid, type: String
  field :password_changed, type: Boolean, default: false

  ## Lockable
  # field :failed_attempts,       type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,          type: String # Only if unlock strategy is :email or :both
  # field :locked_at,             type: Time

  ## Token authenticatable
  # field :authentication_token,  type: String

  field :name, type: String

  field :notification_donated, type: Boolean, default: true
  field :notification_new_comment, type: Boolean, default: true

  ## Validators
  validates :email, uniqueness: {case_sensitive: false}, if: :email_changed?
  validates :name, presence: true
  ## Relations
  has_and_belongs_to_many :projects
  has_many :invites
  has_many :fees
  belongs_to :attachment

  has_many :comments
  has_many :cards

  attr_accessor :invite_token

  attr_accessor :fbook_access_token

  after_create :check_invite_token, :merge_another_invites
  ## Methods
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = find_and_update_with_facebook_id auth.info.email, auth.uid
    user = User.where(provider: auth.provider, uid: auth.uid).first if user.nil?
    if user.nil?
      user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0, 20],
                         confirmed_at: DateTime.now

      )
    end
    user.fbook_access_token = (credentials = auth["credentials"]) ? credentials["token"] : nil
    user.save!
    user
  end

  def self.find_and_update_with_facebook_id email, uid
    user = User.where(email: email).first
    user.update_attribute :uid, uid if user.present?
    user
  end

  def avatar
      current_attachment.image
  end

  def pending_invites
    invites.not_in(:project_id => projects.map(&:id))
  end

  def check_invite_token
    return unless invite_token
    invite = Invite.where(:invite_token => invite_token).first

    if invite
      invite.user = self
      invite.save
      invite.reload
      invite.accept!
    end
  end


  def merge_another_invites
    vals = []
    [:email, :uid].each do |field|
      val = self.send(field)
      if val.present?
        vals << {field => val}
      end
    end
    Invite.where(:user_id => nil).any_of(*vals).update_all(:user_id => id) if vals.any?

  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def current_attachment
    attachment ? attachment : Attachment.new
  end

  private

end

