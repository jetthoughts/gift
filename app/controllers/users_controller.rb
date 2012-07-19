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
    #Koala::Facebook::GraphAPI.new
    oauth = Koala::Facebook::OAuth.new(FBOOK_APPLICATION_ID, FBOOK_SECRET_KEY)
    #@oauth_url = oauth.url_for_oauth_code
    render 'invites/facebook', layout: false
  end
end
