class PaymentTransaction
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to  :fee

  field   :params,          :type => Hash
  field   :data,        :type => Hash

  def to_partial_path
    "admin/orders/payment_transactions/#{fee.payment_method.class.partialize}"
  end

end
