class UpdateNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String

  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  def self.new_card_created_event card
    UpdateNotification.create({message: I18n.t('general.events.new_card_created', user: card.user.name, project: card.project.name, time: Time.now)})
  end

  def self.project_updated_event project
    UpdateNotification.create({message: I18n.t('general.events.project_updated', user: project.admin.name, project: project.name, time: Time.now)})
  end
end
