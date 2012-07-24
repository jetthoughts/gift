class Withdraw
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :project

  field :paypal_email
  field :amount, type: Float, default: 0
  belongs_to  :payment_method
  
  attr_accessible :payment_method_id, :project, :paypal_email

  validates :payment_method, presence: true
  validates :project, presence: true
  
  validates :amount, presence: true, numericality: true
  validates :paypal_email, presence: true, if: :paypal?

  def check_available_amount
    errors.add(:amount, 'Poll is not available') unless amount <= project.available_amount
  end

  def refund
    self.amount = project.available_amount
    if self.amount < 1
      errors.add(:amount, 'Poll is not available')
      return false
    end

    if (response = paypal.transfer(total_amount_in_cents, paypal_email, { currency: project.currency })).success?       
       save  
    else
      errors.add(:payment_method, "PayPal Error: #{response.message}")
      false
    end
  end

  def paypal?
    payment_method.class.name == 'Paypal::Paypalwp'
  end

  def paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))    
  end

  def config_from_file(file)
    YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
  end

  def total_amount_in_cents    
    (BigDecimal(amount_with_fees.to_s) * 100).round(0).to_i  
  end

  def amount_with_fees
    amount - payment_method.refund_fee
  end
end