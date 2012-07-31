class PayPalInfo < PaidInfo
  require 'valid_email'
  field :email, type: String

  validates_presence_of :email
  validates :email, email: true
end