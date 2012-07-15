class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :project
  belongs_to :user

  field :email
  field :name
  field :invite_token

  validates :project, :name, presence: true
  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  before_create :set_token
  before_validation :set_user, :on => :create

  after_create :send_notification


  def self.generate_uid
    SecureRandom.hex(8)
  end

  def accept!
    if user and !project.users.include? user
      project.users << user
      project.save
    end
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
    self.user.present? ? InvitesMailer.exist_user_notify(self).deliver : InvitesMailer.new_user_notify(self).deliver
  end

end