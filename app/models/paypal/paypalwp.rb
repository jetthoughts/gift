module Paypal
  class Paypalwp < PaymentMethod

     field :paypal_percent, :type => Float, :default => 0.029
     field :transaction_fee, :type => Float, :default => 0.35

    def title
      'Paypal'
    end

    def fee(amount)
      paypal_percent*amount + transaction_fee
    end

  end
end