module Paypal
  class Paypalwp < PaymentMethod

    field :paypal_percent, :type => Float, :default => 0.019
    field :transaction_fee, :type => Float, :default => 0.35
    field :refund_fee, :type => Float, :default => 0.85

    def title
      'Paypal'
    end

    def fee(amount)
      ((amount + transaction_fee) / (1 - paypal_percent).round(4)).round(2) - amount
    end

    def refund total_amount_in_cents, paypal_email, options
      paypal.transfer(total_amount_in_cents, paypal_email, options)
    end

    def paypal
      @paypal ||= ActiveMerchant::Billing::Base.gateway(:paypal_express).new(config_from_file('paypal.yml'))
    end

    private

    def config_from_file(file)
      YAML.load_file(File.join(Rails.root, 'config', file))[Rails.env].symbolize_keys
    end

  end
end