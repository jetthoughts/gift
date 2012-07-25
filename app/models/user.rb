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

  ##facebook invited info uncompleted
  field :info_uncompleted, type: Boolean, default: false

  ## Lockable
  # field :failed_attempts,       type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,          type: String # Only if unlock strategy is :email or :both
  # field :locked_at,             type: Time

  ## Token authenticatable
  # field :authentication_token,  type: String

  field :name, type: String

  field :notification_donated, type: Boolean, default: true
  field :notification_new_comment, type: Boolean, default: true

  mount_uploader :avatar, ImageUploader

  ## Validators
  validates :email, uniqueness: {case_sensitive: false}, if: :email_changed?
  validates :name, presence: true
  ## Relations
  has_and_belongs_to_many :projects
  has_many :invites
  has_many :fees

  has_many :comments
  has_many :cards

  attr_accessor :invite_token

  attr_accessor :fbook_access_token

  after_create :check_invite_token

  ## Methods
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    puts auth
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user && user.info_uncompleted?
      user.update_attributes(name: auth.extra.raw_info.name,
                             email: auth.info.email,
                             password: Devise.friendly_token[0, 20],
                             confirmed_at: DateTime.now,
                             info_uncompleted: false
      )
    elsif user.nil?
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

  #todo: not working
  #def confirmation_required?
  #  !info_uncompleted
  #end

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
    merge_another_invites
  end

  def merge_another_invites
    Invite.where(:user_id => nil, :email => email).update_all(:user_id => id)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
