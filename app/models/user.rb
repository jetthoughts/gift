class User
  include Mongoid::Document
  include Mongo::Voter
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]

  ## Database authenticatable
  field :email,                   type: String, null: false, default: ""
  field :encrypted_password,      type: String, null: false, default: ""

  ## Recoverable
  field :reset_password_token,    type: String
  field :reset_password_sent_at,  type: Time

  ## Rememberable
  field :remember_created_at,     type: Time

  ## Trackable
  field :sign_in_count,           type: Integer, default: 0
  field :current_sign_in_at,      type: Time
  field :last_sign_in_at,         type: Time
  field :current_sign_in_ip,      type: String
  field :last_sign_in_ip,         type: String

  ## Encryptable
  # field :password_salt,         type: String

  ## Confirmable
  field :confirmation_token,      type: String
  field :confirmed_at,            type: Time
  field :confirmation_sent_at,    type: Time
  field :unconfirmed_email,       type: String # Only if using reconfirmable

  ## Omniauth
  field :provider,                type: String
  field :uid,                     type: String
  field :password_changed,        type: Boolean, default: false

  ## Lockable
  # field :failed_attempts,       type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,          type: String # Only if unlock strategy is :email or :both
  # field :locked_at,             type: Time

  ## Token authenticatable
  # field :authentication_token,  type: String
  
  field :name,                    type: String

  mount_uploader :avatar, ImageUploader

  ## Validators
  validates :email, uniqueness: { case_sensitive: false }, if: :email_changed?


  ## Relations
  has_many :projects
  has_many :comments
  has_many :cards

  ## Methods
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20],
                         confirmed_at:DateTime.now
                        )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
