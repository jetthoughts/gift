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
#  validate :check_available_amount

  def check_available_amount
    errors.add(:amount, 'Poll is not available') unless amount <= project.available_amount
  end

  def set_amount
    
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
      puts '*'*100
      p response.message
      errors.add(:payment_method, "PayPal Error: #{response.message}")
      false
    end
  end

  def cc?
    payment_method.class.name != 'Paypal::Paypalwp'
  end

  def paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))
  end

  def config_from_file(file)
    YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
  end

  def total_amount_in_cents    
    (BigDecimal(amount.to_s) * 100).round(0).to_i  
  end

end