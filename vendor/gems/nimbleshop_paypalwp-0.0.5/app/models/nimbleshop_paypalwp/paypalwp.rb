module NimbleshopPaypalwp
  class Paypalwp < PaymentMethod

    field :data
    field :merchant_email
    field :mode

    before_save :set_mode

    validates :merchant_email, email: true, presence: true

    before_validation :strip_attributes

    private

    def set_mode
      self.mode ||= 'test'
    end

    # This is needed because https://github.com/nimbleshop/nimbleshop/blob/master/nimbleshop_core/lib/nimbleshop/core_ext/activerecord_base.rb
    # acts only on core attributes and not on store_accessors.
    def strip_attributes
      self.merchant_email = merchant_email.strip unless merchant_email.nil?
    end

  end
end
