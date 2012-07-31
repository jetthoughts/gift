class BankInfo
  include Mongoid::Document

  ACCOUNT_TYPES = [:checking, :savings]

  field :account_type, type: String
  field :name, type: String
  field :country, type: String
  field :swift_code, type: String
  field :address, type: String
  field :address2, type: String
  field :city, type: String
  field :province, type: String
  field :zip_code, type: String

  validates :account_type, inclusion: {in: ACCOUNT_TYPES.map(&:to_s), message: ''}
  validates_presence_of :name, :country, :swift_code, :address, :city, :province, :zip_code
end
