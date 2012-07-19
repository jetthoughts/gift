module NimbleshopAuthorizedotnet

  class PaymentsController < ::ActionController::Base

    def create
      #order             =  Order.find_by_id!(session[:order_id])
      order = Fee.last
      address_attrs     = order.final_billing_address
      creditcard_attrs  = params[:creditcard].merge(address_attrs)
      creditcard        = Creditcard.new(creditcard_attrs)

      processor         = NimbleshopAuthorizedotnet::Processor.new(order)

      if processor.authorize(creditcard: creditcard)
        @output = "window.location='/projects/#{order.project.id}/'"
      else
        error = processor.errors.first
        Rails.logger.info "Error: #{error}"
        @output = "alert('#{error}')"
      end

      respond_to do |format|
        format.js do
          render js: @output
        end
      end

    end

  end

end
