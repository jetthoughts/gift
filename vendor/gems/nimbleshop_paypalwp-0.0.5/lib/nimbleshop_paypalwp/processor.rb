module NimbleshopPaypalwp
  class Processor < Processor::Base

    attr_reader :order, :payment_method

    def initialize(options = {})
      @paypal_ipn = paypal_ipn(options[:raw_post])
      @order = Order.find_by_number!(@paypal_ipn.invoice)
      @payment_method = NimbleshopPaypalwp::Paypalwp.first
    end

    private

    def paypal_ipn(raw_post)
      # ActiveMerchant::Billing::Integrations::Paypal::Notification is a subclass of
      # ActiveMerchant::Billing::Integrations::Notification
      #
      # And ActiveMerchant::Billing::Integrations::Notification dependds on money gem
      ActiveMerchant::Billing::Integrations::Paypal::Notification.new(raw_post)
    end

    def do_capture(options = {})
      success = amount_match?
      record_transaction('captured', success: success)

      if success
        order.update_attributes(purchased_at: purchased_at, payment_method: payment_method)
        order.kapture
      end

      success
    end

    def do_authorize(options = {})
      success = amount_match?
      record_transaction('authorized', success: success)

      if success
        order.update_attributes(purchased_at: purchased_at, payment_method: payment_method)
        order.authorize
      end

      success
    end

    def do_void(options = {})
    end

    def do_purchase(options = {})
      success = amount_match?
      record_transaction('purchased', success: success)

      if success
        order.update_attributes(purchased_at: @paypal_ipn.received_at, payment_method: payment_method)
        order.purchase
      end

      success
    end


    def record_transaction(operation, options = {})
      order.payment_transactions.create(options.merge(amount: @paypal_ipn.amount.cents,
                                                      params: { ipn: @paypal_ipn.raw },
                                                      transaction_gid: @paypal_ipn.transaction_id,
                                                      operation: operation))

    end

    def amount_match?
      @paypal_ipn.amount.cents == order.total_amount_in_cents
    end

    def purchased_at
      Time.strptime(@paypal_ipn.params['payment_date'], "%H:%M:%S %b %d, %Y %z")
    end
  end
end
