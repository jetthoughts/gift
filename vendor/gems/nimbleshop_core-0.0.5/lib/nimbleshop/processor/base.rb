module Processor
  class Base

    extend ActiveModel::Callbacks

    define_model_callbacks  :transaction, :authorize,
                                          :kapture,
                                          :purchase,
                                          :refund,
                                          :void

    before_transaction :set_active_merchant_mode

    def kapture(options = {})
      execute(:kapture, options)
    end

    def authorize(options = {})
      execute(:authorize, options)
    end

    def void(options = {})
      execute(:void, options)
    end

    def purchase(options = {})
      execute(:purchase, options)
    end

    def refund(options = {})
      execute(:refund, options)
    end

    private

    def execute(operation, options = {})
      run_callbacks(:transaction) do
        run_callbacks(operation) do
          send("do_#{operation}", options)
        end
      end
    end

    # this method can be overriden by individual payment method
    def set_active_merchant_mode
      mode = Rails.env.production? ? :production : :test
      ActiveMerchant::Billing::Base.mode = mode
    end

  end
end
