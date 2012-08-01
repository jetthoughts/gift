class UpdateNotifications
  include Mongoid::Document

  def self.new_card_created_event card

  end

  def self.project_updated_event project

  end
end
