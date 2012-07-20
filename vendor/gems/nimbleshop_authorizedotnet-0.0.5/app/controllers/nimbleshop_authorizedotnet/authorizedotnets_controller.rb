module NimbleshopAuthorizedotnet

  class AuthorizedotnetsController < ::Admin::PaymentMethodsController

    before_filter :load_payment_method

    def update
      respond_to do |format|
        if @payment_method.update_attributes(post_params[:authorizedotnet])
          format.js  {
            flash[:notice] = 'Authorize.net record was successfully updated'
            render js: "window.location = '/admin/payment_methods'"
          }
        else
          msg =  @payment_method.errors.full_messages.first
          error =  %Q[alert("#{msg}")]
          format.js { render js: error }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @payment_method.destroy
          format.js {
            flash[:notice] = 'Authorize.net record was successfully deleted'
            render js: "window.location = '/admin/payment_methods'"
          }
        else
          format.js { render js: 'Authorize.net record could not be deleted. Please try again later.' }
        end
      end
    end

    private

    def post_params
      params.permit(authorizedotnet: [:mode, :ssl, :login_id, :transaction_key, :company_name_on_creditcard_statement])
    end

    def load_payment_method
      @payment_method = NimbleshopAuthorizedotnet::Authorizedotnet.instance
    end

  end

end
