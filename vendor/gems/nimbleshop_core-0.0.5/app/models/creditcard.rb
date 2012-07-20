class Creditcard
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend  ActiveModel::Callbacks
  include ActiveModel::Validations::Callbacks

  attr_accessor :cvv, :expires_on, :number, :name, :address1, :address2,
                :cardtype, :month, :year, :state, :zipcode

  alias :verification_value :cvv # ActiveMerchant needs this

  delegate :display_number, to: :active_merchant_creditcard

  before_validation :strip_non_numeric_values, if: :number


  validates_presence_of :number,     message: "^Please enter credit card number"
  validates_numericality_of :number, message: "^Please check the credit card number you entered"
  validates_presence_of :cvv,        message: "^Please enter CVV"

  validate  :validation_of_name,        if: lambda { |r| r.errors.empty? }
  validate  :validation_of_cardtype,        if: lambda { |r| r.errors.empty? }
  validate  :validation_by_active_merchant, if: lambda { |r| r.errors.empty? }

  def initialize(attrs = {})
    sanitize_month_and_year(attrs)

    attrs.each do | name, value |
      send("#{name}=", value)
    end
  end

  def verification_value?
    true # ActiveMerchant needs this
  end

  def persisted?
    false
  end

  def first_name
    String(name).split(' ')[0] || ''

  end

  def last_name
    String(name).split(' ')[1] || ''
  end

  private


  def add_user_data(options = {})
    options[:first_name]  = first_name
    options[:last_name]   = last_name
  end

  def add_credit_card_data(options = {})
    options[:year]    = year
    options[:month]   = month
    options[:number]  = number
    options[:type]    = cardtype
    options[:verification_value]  = verification_value
  end

  def strip_non_numeric_values
    self.number = number.to_s.gsub('-', '').strip
  end

  def validation_of_name
    unless name && name=~/\w+\s\w+/
      errors.add(:base, 'Please fill name')
    end
  end

  def validation_of_cardtype
    if cardtype = ActiveMerchant::Billing::CreditCard.type?(number)
      self.cardtype = cardtype
    else
      errors.add(:base, 'Please check credit card number. It does not seem right.')
    end
  end

  def validation_by_active_merchant
    amcard = active_merchant_creditcard

    unless amcard.valid?
      amcard.errors.full_messages.each { |message| errors.add(:base, message) }
    end

    amcard.errors.any?
  end

  def active_merchant_creditcard
    options = {}
    add_user_data(options)
    add_credit_card_data(options)

    ActiveMerchant::Billing::CreditCard.new(options)
  end

  def sanitize_month_and_year(attrs)
    month = attrs.delete("expires_on(2i)")
    year =  attrs.delete("expires_on(1i)")
    day = attrs.delete("expires_on(3i)")
    attrs.reverse_merge!(month: month)
    attrs.reverse_merge!(year: year)
  end

end
