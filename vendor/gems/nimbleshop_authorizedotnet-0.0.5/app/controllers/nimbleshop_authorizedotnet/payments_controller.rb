module NimbleshopAuthorizedotnet

  class PaymentsController < ::ActionController::Base

    def create
      order = Fee.find(session[:fee_id])
      creditcard_attrs  = params[:creditcard]
      creditcard        = Creditcard.new(creditcard_attrs)

      processor         = NimbleshopAuthorizedotnet::Processor.new(order)

      if processor.purchase(creditcard: creditcard)
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
