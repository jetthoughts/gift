class UsersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def show
    @user = current_user
    render 'users/show'
  end

  def update_token
    if current_user && params[:token]
      current_user.fbook_access_token = params[:token]
      current_user.save
    end
    render :nothing => true
  end
end
