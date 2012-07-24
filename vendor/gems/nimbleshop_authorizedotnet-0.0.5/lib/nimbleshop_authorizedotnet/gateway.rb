module NimbleshopAuthorizedotnet
  module Gateway
    def self.instance
      record = NimbleshopAuthorizedotnet::Authorizedotnet.instance

      ActiveMerchant::Billing::Gateway.logger = Rails.logger if record.mode.to_s == 'test'
      ActiveMerchant::Billing::AuthorizeNetGateway.new( record.credentials )
    end
  end
end
