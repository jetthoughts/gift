class PayPalInfo < PaidInfo
  field :email, type: String

  validates_presence_of :email
end