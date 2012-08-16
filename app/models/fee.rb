class Fee
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :project

  validates :project, :user, presence: true

  field :amount, type: Float, default: 0
  field :visible, type: Boolean, default: true

  attr_accessible :credit_card, :payment_method_id, :project, :amount, :visible

  validates :amount, presence: true, numericality: {greater_than: 1}

  #paypal  methods should be moved from here
  def complete_paypal(token, payer_id)
    response = payment_method.paypal.purchase(total_amount_in_cents, {:token => token, :payer_id => payer_id, :description => description, :currency => self.currency})
    transaction_gid = response.params['transaction_id']
    options = { operation:          'purchase',
                params:             response.params,
                success:            response.success?,
                data:           {},
                transaction_gid:    transaction_gid }
    self.payment_transactions.create!(options)

    if response.success?
      if response.params['payment_status'] == 'Completed'
        self.purchase
        self.amount = response.params['gross_amount'].to_f - response.params['fee_amount'].to_f - response.params['tax_amount'].to_f
        save
      end
    else
      errors.add(:payment_method, "PayPal Error: #{response.message}")
      false
    end
  end

  def start_paypal(return_url, cancel_return_url)
    if (@response = payment_method.paypal.setup_purchase(total_amount_in_cents, {:return_url => return_url, :cancel_return_url => cancel_return_url, :description => description, :currency => self.currency})).success?
      payment_method.paypal.redirect_url_for(@response.params['token'])
    else
      errors.add(:payment_method, "PayPal Error: #{@response.message}")
      false
    end
  end

  def cc?
    payment_method.class.name != 'Paypal::Paypalwp'
  end

  def description
    "Your fee #{amount_with_fees} in #{currency} for donation with fee"
  end

  def number
    self.id
  end

  def total_amount_in_cents
    (BigDecimal(amount_with_fees.to_s) * 100).round(0).to_i
  end

  def amount_with_fees
    payment_method.amount_with_fees(amount)
  end

  def currency
    project.currency
  end

  # paypal payment method block end

  def run_purchase_notify
    self.delay.purchase_notify
  end

  def purchase_notify
    return unless project
    UpdateNotification.new_fee_donated self
    recipients.each do |u|
      CommentsMailer.new_donation(self, u).deliver
    end
  end

  def recipients
    project.users.where(:_id.ne => user.id, :notification_donated => true)
  end
end