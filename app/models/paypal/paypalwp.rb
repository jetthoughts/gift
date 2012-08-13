module Paypal
  class Paypalwp < PaymentMethod

    field :paypal_percent, :type => Float, :default => 0.019
    field :transaction_fee, :type => Float, :default => 0.35
    field :refund_fee, :type => Float, :default => 1.0

    def title
      'Paypal'
    end

    def fee(amount)
      ((amount * paypal_percent / (1 - paypal_percent))*100).ceil.to_f/100 + transaction_fee
    end

    def refund total_amount_in_cents, paypal_email, options
      paypal.transfer(total_amount_in_cents, paypal_email, options)
    end

    private

    def paypal
      @paypal ||= ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))
    end

    def config_from_file(file)
      YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
    end

  end
end