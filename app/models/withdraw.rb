class Withdraw
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :project

  field :paypal_email
  field :amount, type: Float, default: 0
  belongs_to  :payment_method
  
  attr_accessible :payment_method, :project, :paypal_email, :payment_method_id

  validates :payment_method, presence: true
  validates :project, presence: true
  
  validates :amount, presence: true, numericality: true
  validates :paypal_email, presence: true, if: :paypal?

  def check_available_amount
    errors.add(:amount, 'Pool is not available') unless amount <= project.available_amount
  end

  def self.build_with_project project
    paid_info = project.paid_info
    if project.paid_type == 'pay_pal'
      payment_method = Paypal::Paypalwp.instance
      self.new project: project, payment_method: payment_method, paypal_email: paid_info.email
    else
      nil
    end
  end

  def refund
    self.amount = project.available_amount
    if self.amount < 1
      errors.add(:amount, 'Pool is not available')
      logger.debug 'Pool is not available'
      return false
    end
    if (response = payment_method.refund(total_amount_in_cents, paypal_email, { currency: project.currency })).success?
      logger.debug 'Success'
      save
    else
      errors.add(:payment_method, "PayPal Error: #{response.message}")
      logger.debug "PayPal Error: #{response.message}"
      false
    end
  end

  def paypal?
    payment_method.class.name == 'Paypal::Paypalwp'
  end

  def success?
    !new?
  end

  def total_amount_in_cents    
    (BigDecimal(amount_with_fees.to_s) * 100).round(0).to_i  
  end

  def amount_with_fees
    (amount - payment_method.refund_fee).round(2)
  end
end