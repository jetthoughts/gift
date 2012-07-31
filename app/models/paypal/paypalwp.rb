module Paypal
  class Paypalwp < PaymentMethod

     field :paypal_percent, :type => Float, :default => 0.019
     field :transaction_fee, :type => Float, :default => 0.35
     field :refund_fee, :type => Float, :default => 1.0
     
    def title
      'Paypal'
    end

    def fee(amount)
      ((amount * paypal_percent / (1 - paypal_percent))*100).ceil.to_f/100  + transaction_fee
    end

  end
end