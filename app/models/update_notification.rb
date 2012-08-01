class UpdateNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  PROJECT_TRACK_COLUMNS = [:name, :description, :fixed_amount, :deadline, :end_type]

  field :message, type: String

  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  def self.new_card_created_event card
    UpdateNotification.create({message: I18n.t('general.events.new_card_created', user: card.user.name, project: card.project.name, time: Time.now)})
  end

  def self.project_updated_event project
    changed_columns = []
    PROJECT_TRACK_COLUMNS.each do |column|
      changed_columns << column.to_s if project.send("#{column.to_s}_changed?")
    end
    UpdateNotification.create({message: I18n.t('general.events.project_updated', user: project.admin.name,
                                               columns: changed_columns.to_sentence, project: project.name, time: Time.now)})
  end
end
