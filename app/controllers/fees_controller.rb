class FeesController < ApplicationController
   before_filter :find_project

   def new
     @fee = @project.fees.build
   end

   def create
     @fee = current_user.fees.build(:project => @project)
     if (redirect_url = @fee.start_paypal(paypal_project_fees_url(@project), new_project_fee_url(@project)))
       redirect_to redirect_url
     else
       render :new, :notice => "We have problem with gateway"
     end
   end

   def paypal
     @fee  =  current_user.fees.build(:project => @project)
     success = @fee.complete_paypal(params[:token], params[:PayerID])
     redirect_to (success ? url_for(@project) : new_project_fee_url(@project))
   end

  private

  def find_project
    @project  = current_user.projects.find(params[:project_id])
  end

end