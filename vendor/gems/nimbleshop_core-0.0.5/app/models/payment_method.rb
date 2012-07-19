class PaymentMethod
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :data
  field   :name
  field   :description
  field   :type
  #field   :permalink

  #include Permalink::Builder

  # By default payment_method does not require that application must use SSL.
  # Individual payment method should override this method.
  def use_ssl?
    false
  end

  def demodulized_underscore
    self.class.name.demodulize.underscore
  end

  def self.partialize
    name.gsub("PaymentMethod::","").underscore
  end
end
