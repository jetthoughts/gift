class PaidInfo
  include Mongoid::Document
  embedded_in :project

  def account_identifier
    case self.class
      when AmazonInfo then destination_address
      when PayPalInfo then email
      when BankInfo then account_number
      else
        nil
    end
  end
end