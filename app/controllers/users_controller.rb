class UsersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!, except: [:facebook_invite]

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
    #error_reason
    @oauth = Koala::Facebook::OAuth.new(FBOOK_APPLICATION_ID, FBOOK_SECRET_KEY)
    fb_params = @oauth.parse_signed_request(params[:signed_request]) if params
    user_id = fb_params['user_id']

    if user_id
      @invites = Invite.where(fb_id: user_id).entries
      graph = Koala::Facebook::API.new(fb_params['oauth_token'])
      result = graph.get_object('me')
      @name = result['name']
      render 'invites/facebook_exist_user', layout: false
    else
      render 'invites/facebook_new_user', layout: false
    end
  end
end
