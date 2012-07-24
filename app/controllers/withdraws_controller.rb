class WithdrawsController < ApplicationController
  before_filter :find_project

  def index
    unless @project.can_withdraw?
      render 'too_little_collected'
      return
    end
   @with_draw = @project.withdraws.build
  end

  def create
    @with_draw = @project.withdraws.build(model_params)
    if @with_draw.valid? and @with_draw.refund
    	redirect_to @project
    else
      render :index
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

end
