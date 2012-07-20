module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

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

    def self.instance
      self.first
    end

    def title
      'CreditCard'
    end

    private

    def set_ssl
      self.ssl ||= 'disabled'
    end

  end
end
