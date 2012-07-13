class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :project
  belongs_to :user

  field :email
  field :name

  validates :project, :email, presence: true

  after_create :send_notification

  private

  def send_notification
    InvitesMailer.new_user_notify(self).deliver
  end

end