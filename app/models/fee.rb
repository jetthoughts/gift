class Fee
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :project

  validates :project, :user, presence: true

  #field :payment_method
  field :amount, type: Float
  field :visible, type: Boolean, default: true
  field :state


  field :payment_status, default: 'abandoned'

  has_many    :payment_transactions, dependent:  :destroy
  belongs_to  :payment_method



  state_machine :payment_status, initial: :abandoned do

    event(:authorize) { transition abandoned:   :authorized }
    event(:pending)   { transition abandoned:   :pending    }
    event(:kapture )  { transition authorized:  :purchased  }
    event(:refund)    { transition purchased:   :refunded   }

    event(:purchase)  { transition [:abandoned,  :pending] =>  :purchased  }
    event(:void)      { transition [:authorized, :pending] =>  :voided     }

    state all - [ :abandoned ] do
      validates :payment_method, presence: true
    end
  end



  #validates :payment_method, :inclusion => {:in => %w(cc paypal)}

  attr_accessible :credit_card, :payment_method, :project, :amount, :visible

  validates :amount, presence: true, numericality: {greater_than: 1}

  scope :paid, where(:state => 'paid')
  scope :idle, where(:state => 'idle')

  def credit_card
    @credit_card
  end

  def credit_card=(options)
    @credit_card = ActiveMerchant::Billing::CreditCard.new(options)
  end

  def cc_payment ip
    response = cc.purchase(fee_in_cents, credit_card, :ip => ip)
    if response.success?
      #self.card_number = creditcard.display_number
      #self.card_expiration = "%02d-%d" % [@creditcard.expiry_date.month, @creditcard.expiry_date.year]
      #self.billing_id = response.authorization
      self.pay
    else
      errors.add("Credit card Error: #{response.message}")
      false
    end
  end

  def complete_paypal(token, payer_id)
    if (response = paypal.purchase(fee_in_cents, {:token => token, :payer_id => payer_id, :description => description})).success?
      self.pay
      # self.real_amount = response.params['gross_amount'].to_f - response.params['fee_amount'].to_f - response.params['tax_amount'].to_f
      # save
    else
      errors.add("PayPal Error: #{response.message}")
      false
    end
  end

  def start_paypal(return_url, cancel_return_url)
    if (@response = paypal.setup_purchase(fee_in_cents,{:return_url => return_url, :cancel_return_url => cancel_return_url, :description => description})).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add("PayPal Error: #{@response.message}")
      false
    end
  end

  def cc?
    true
    #payment_method == 'cc'
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
    "Your fee $#{amount} in donation"
  end

  def final_billing_address
    {
        :first_name     => "John",
        :last_name     => "Smith",
        :address1 => '123 First St.',
        :address2 => '',
        :state    => 'CA',

        :zipcode      => '90068'
    }
  end

  def number
    self.id
  end

  def total_amount_in_cents
    amount.to_i*100
  end

end