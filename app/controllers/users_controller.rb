class UsersController < ApplicationController
  respond_to :html

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
    @oauth = Koala::Facebook::OAuth.new(FBOOK_APPLICATION_ID, FBOOK_SECRET_KEY, facebook_url)
    fb_params = @oauth.parse_signed_request(params[:signed_request]) if params
    oauth_token = fb_params['oauth_token']

    if oauth_token.nil?
      redirect_to omniauth_authorize_url(:facebook)
      #redirect_to @oauth.url_for_oauth_code(:permissions => "email")
    else
      user_id = fb_params['user_id']
      @invites = Invite.where(fb_id: user_id).entries
      graph = Koala::Facebook::API.new(fb_params['oauth_token'])
      result = graph.get_object('me')
      @name = result['name']
      render 'invites/facebook_exist_user', layout: false
    end
  end
  #error_reason
end
