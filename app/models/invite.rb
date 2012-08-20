require 'smsnotifier'
class Invite
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :project
  belongs_to :user

  field :fb_id
  field :email
  field :phone

  field :name
  field :creator_name
  field :invite_token

  validate :present_email_or_id
  validates :project, :name, presence: true
  validates :email,
            :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
            :allow_blank => true

  validates :phone,
            :format => {:with => /^\+\d{10,15}$/i},
            :allow_blank => true

  validates :fb_id, :uniqueness => true, :allow_blank => true
  validates :email, :uniqueness => {:scope => :project_id},  :allow_blank => true
  before_create :set_token
  before_validation :set_user, :on => :create



  after_create :send_notification, :send_sms_notification

  def self.generate_uid
    SecureRandom.hex(8)
  end

  def accept!
    logger.debug '***********************************************'
    if user and !project.users.include? user
      project.users << user
      project.save

      user.projects << project
      user.save
      logger.debug '**************save accept!*********************'
    end
    self.destroy
  end

  def send_notification
    return if email.blank?
    self.user.present? ? InvitesMailer.exist_user_notify(self).deliver : InvitesMailer.new_user_notify(self).deliver
  end

  def send_sms_notification
    return if phone.blank?
    SMSNotifier.instance.exist_user_notify(self)
  end

  private

  def blank_email_and_id_and_phone?
    email.blank? and fb_id.blank? and phone.blank?
  end

  def blank_email_and_id?
    email.blank? and fb_id.blank?
  end

  def present_email_or_id
    if blank_email_and_id_and_phone?
      errors[:base] << "Invite must contains email or facebook user id"
    end
  end

  def set_user
    return if user || blank_email_and_id?
    self.user = email.blank? ? User.where(:uid => fb_id).first : User.where(:email => email).first
  end

  def set_token
    self.invite_token = self.class.generate_uid
  end

  handle_asynchronously :send_notification
  handle_asynchronously :send_sms_notification
end