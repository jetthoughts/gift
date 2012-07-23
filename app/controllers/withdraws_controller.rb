class WithdrawsController < ApplicationController
  before_filter :find_project

  def index
   @with_draw = @project.withdraws.build
  end

  def create
    @with_draw = @project.withdraws.build(model_params)

    if @with_draw.errors.empty? and @with_draw.refund
    	redirect_to @project
    else
      render :index
    end
  end


  def paypal
  	puts '3'*100
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

end
