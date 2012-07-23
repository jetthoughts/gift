module Paypal
  class Paypalwp < PaymentMethod
    
    def self.instance
      self.first
    end

    def title
      'Paypal'
    end

  end
end