module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    field :transaction_fee, :type => Float, :default => 0.1

    field :data, :type => Hash
    field :login_id
    field :transaction_key
    field :company_name_on_creditcard_statement
    field  :ssl

    before_save :set_ssl

    validates_presence_of :login_id, :transaction_key, :company_name_on_creditcard_statement

    def credentials
      { login: login_id, password: transaction_key }
    end

    def use_ssl?
      self.ssl == 'enabled'
    end

    def kapture!(order)
      processor = NimbleshopAuthorizedotnet::Processor.new(order)
      processor.kapture
      order.kapture!
    end

    def title
      'CreditCard'
    end

    def fee(amount)
      transaction_fee
    end

    private

    def set_ssl
      self.ssl ||= 'disabled'
    end

  end
end
