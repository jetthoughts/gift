module NimbleshopAuthorizedotnet
  class Authorizedotnet < PaymentMethod

    field :data, :type => Hash
    field :login_id
    field :transaction_key
    field :company_name_on_creditcard_statement
    field :mode
    field  :ssl

    before_save :set_mode, :set_ssl

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

    private

    def set_mode
      self.mode ||= 'test'
    end

    def set_ssl
      self.ssl ||= 'disabled'
    end

  end
end
