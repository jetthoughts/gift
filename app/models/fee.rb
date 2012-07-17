class Fee
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :project

  validates :project, :user, presence: true

  field :payment_method
  field :amount, type: Float
  validates :payment_method, :inclusion => {:in => %w(cc paypal)}

  attr_accessible :credit_card, :payment_method, :project

  validate :validate_card, if: -> { self.cc? }

  def credit_card
    @credit_card
  end

  def credit_card=(options)
    @credit_card = ActiveMerchant::Billing::CreditCard.new(options)
  end

  def cc_payment ip
    response = cc.purchase(project.fee_in_cents, credit_card, :ip => ip)
    if response.success?
      #self.card_number = creditcard.display_number
      #self.card_expiration = "%02d-%d" % [@creditcard.expiry_date.month, @creditcard.expiry_date.year]
      #self.billing_id = response.authorization
      self.payment_method = 'cc'
      self.amount = response.params['amount'].to_f
      save
    else
      errors.add("Credit card Error: #{response.message}")
      false
    end
  end

  def complete_paypal(token, payer_id)
    if (response = paypal.purchase(project.fee_in_cents, {:token => token, :payer_id => payer_id, :description => description})).success?
      self.payment_method = 'paypal'
      self.amount = response.params['gross_amount'].to_f
      save
    else
      errors.add("PayPal Error: #{response.message}")
      false
    end
  end

  def start_paypal(return_url, cancel_return_url)
    if (@response = paypal.setup_purchase(project.fee_in_cents,{:return_url => return_url, :cancel_return_url => cancel_return_url, :description => description})).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add("PayPal Error: #{@response.message}")
      false
    end
  end

  def cc?
    payment_method == 'cc'
  end

  def paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))
  end

  def cc
    @cc ||=  ActiveMerchant::Billing::PaypalGateway.new(config_from_file('paypal.yml'))
  end

  def config_from_file(file)
    YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
  end

  def description
    'Your fee in donation'
  end

  private

  def validate_card
    unless credit_card && credit_card.valid?
      errors.add(:credit_card, ' not valid')
        if credit_card
          credit_card.errors.each do |key, val|
          errors.add(key, val.join(', '))
        end
      end
    end

  end

end