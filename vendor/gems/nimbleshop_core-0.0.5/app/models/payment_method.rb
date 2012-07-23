class PaymentMethod
  include Mongoid::Document
  include Mongoid::Timestamps

  field   :data, type: Hash
  field   :name
  field   :description
  field   :type
  field   :mode, default: 'test'
  field   :permalink

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

  def self.instance
    where(:mode => mode).first
  end

  def self.mode
    Rails.env == 'production' ? 'production' : 'test'
  end

  def total_amount_in_cents amount
    amount + fee(amount)
  end

  def fee(amount)
    0
  end

end
