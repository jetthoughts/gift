module Paypal
  class Paypalwp < PaymentMethod
    def self.instance
      self.first || self.create
    end

    def title
      'Paypal'
    end

  end
end