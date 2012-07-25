class UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :except => [:facebook_invite]

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

  def facebook_invite
    if current_user.nil?
      session[:back] = facebook_url
      redirect_to omniauth_authorize_path(User, :facebook)
    else
      user_id = current_user.uid
      @name = current_user.name
      @invites = Invite.where(fb_id: user_id).entries
      render 'invites/facebook', layout: false
    end
  end
end
