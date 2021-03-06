class FeesController < ApplicationController
  before_filter :find_project

  def new
    @fee = @project.fees.build
  end

  def create
    @fee = current_user.fees.create(model_params(:project => @project))
    if @fee.errors.empty?
      if @fee.cc?
        redirect_to [:edit, @project, @fee]
      else
        if (redirect_url = @fee.start_paypal(paypal_project_fee_url(@project, @fee), new_project_fee_url(@project)))
          redirect_to redirect_url
        else
          render :new, :notice => "We have problem with gateway"
        end
      end
    else
      render :new
    end
  end

  def edit
    @fee = current_user.fees.find(params[:id])
    session[:fee_id] = @fee.id
    @creditcard = Creditcard.new
  end

  def paypal
    @fee = current_user.fees.find(params[:id])
    success = @fee.complete_paypal(params[:token], params[:PayerID])
    redirect_to (success ? url_for(@project) : new_project_fee_url(@project))
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

end