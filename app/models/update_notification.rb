class UpdateNotification
  include Mongoid::Document
  include Mongoid::Timestamps

  PROJECT_TRACK_COLUMNS = [:name, :description, :deadline, :fixed_amount]

  ADMIN_EVENTS = %w(withdraw_success withdraw_failure project_change_end_type new_fee_donated_visible new_fee_donated_hidden)

  field :event_type, type: String
  field :event_params, type: Hash

  belongs_to :project

  scope :ordered_by_date, -> do
    order_by [[:created_at, :desc]]
  end

  scope :admin_events, where(:event_type.in => ADMIN_EVENTS)

  def self.new_card_created_event card
    UpdateNotification.create({project: card.project, event_type: 'new_card_created', event_params: {user: card.user.name}})
  end

  def self.project_updated_event project
    return unless project.changed?

    project_updated_columns_event project
    project_end_type_event project
    project_participant_event project
  end

  def self.project_updated_columns_event project
    changed_columns = []
    PROJECT_TRACK_COLUMNS.each do |column|
      changed_columns << column.to_s if project.send("#{column.to_s}_changed?")
    end

    changed_columns.delete('fixed_amount') if project.fixed_amount_change.present? and project.fixed_amount_change.include? nil

    if changed_columns.present?
      event_type = 'project_updated'
      event_params = {user: project.admin.name, columns: changed_columns.to_sentence}
      UpdateNotification.create({project: project, event_type: event_type, event_params: event_params})
    end
  end

  def self.project_end_type_event project
    if project.end_type_changed?
      event_type = 'project_change_end_type'
      event_params = {user: project.admin.name, type: project.end_type, amount: (project.fixed_amount.present? ? project.fixed_amount : '')}
      UpdateNotification.create({project: project, event_type: event_type, event_params: event_params})
    end
  end

  def self.project_participant_event project
    if project.participants_add_own_suggestions_changed?
      event_type = project.participants_add_own_suggestions ? 'project_allow_gift_suggestion' : 'project_prohibite_gift_suggestion'
      UpdateNotification.create({project: project, event_type: event_type, event_params: {user: project.admin.name}})
    end
  end

  def self.new_fee_donated fee
    event_params = {user: fee.user.name}
    if fee.visible
      event_type = 'new_fee_donated_visible'
      event_params = event_params.merge({amount: fee.amount})
    else
      event_type = 'new_fee_donated_hidden'
    end
    UpdateNotification.create({project: fee.project, event_type: event_type, event_params: event_params})
  end

  def self.new_withdraw withdraw
    event_params = {amount: withdraw.amount, amount_with_fees: withdraw.amount_with_fees, success: withdraw.success?, error: withdraw.errors.messages.values.join(', ')}
    event_type =  withdraw.success? ? 'withdraw_success' : 'withdraw_failure'
    UpdateNotification.create({project: withdraw.project, event_type: event_type, event_params: event_params})
  end

end