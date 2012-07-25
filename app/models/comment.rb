class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, :type => String
  validates :text, presence: true

  ## Relations
  belongs_to :user
  belongs_to :project

  after_create :run_notify

  ## Scopes
  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  def recipients
    project.users.where(:_id.ne => user.id, :notification_new_comment => true)
  end

  private

  def run_notify
    self.delay.notify
  end

  def notify
    return unless project
    recipients.each do |u|
      CommentsMailer.new_comment(self, u).deliver
    end
  end

end
