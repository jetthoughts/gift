class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :project
  belongs_to :user

  field :email
  field :name
  field :invite_token

  validates :project, :email, presence: true


  before_create :set_token
  before_validation :set_user, :on => :create

  after_create :send_notification


  def self.generate_uid
    SecureRandom.hex(8)
  end

  private

  def set_user
    return if user
    self.user = User.where(:email => email).first
  end

  def set_token
    self.invite_token = self.class.generate_uid
  end

  def send_notification
    InvitesMailer.new_user_notify(self).deliver
  end

end