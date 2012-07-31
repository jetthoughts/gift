class BankInfo < PaidInfo
  field :name, type: String
  field :account_number, type: String
  field :bank_number, type: String

  validates_presence_of :name, :account_number, :bank_number
  validates_numericality_of :account_number, :bank_number
end