class UpdateNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  PROJECT_TRACK_COLUMNS = [:name, :description, :fixed_amount, :deadline, :end_type]

  field :event_type, type: String
  field :event_params, type: Hash

  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  def self.new_card_created_event card
    UpdateNotification.create({event_type: 'new_card_created', event_params: {user: card.user.name, project: card.project.name, time: Time.now.to_s}})
  end

  def self.project_updated_event project
    return unless project.changed?

    changed_columns = []
    PROJECT_TRACK_COLUMNS.each do |column|
      changed_columns << column.to_s if project.send("#{column.to_s}_changed?")
    end

    UpdateNotification.create({event_type: 'project_updated', event_params: {user: project.admin.name,
                                                                             columns: changed_columns.to_sentence, project: project.name, time: Time.now.to_s}})
  end

  def self.new_fee_donated fee
    return unless fee.visible
    UpdateNotification.create({event_type: 'new_fee_donated', event_params: {user: fee.user.name,
                                                                             project: fee.project.name, amount: fee.amount, time: Time.now.to_s}})
  end
end
