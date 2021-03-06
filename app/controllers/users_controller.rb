class UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :except => [:facebook_invite]
  before_filter :find_user, only: :show

  def show
    render 'users/show'
  end

  def update_token
    if current_user && params[:token]
      current_user.fbook_access_token = params[:token]
      current_user.save
    end
    render nothing: true
  end

  def facebook_invite
    logger.debug '*****************************************************************************'
    if current_user.nil?
      session[:back] = facebook_url
      redirect_to omniauth_authorize_path(User, :facebook)
    else
      session[:back] = nil
      user_id = current_user.uid
      @name = current_user.name
      @invites = Invite.where(fb_id: user_id).entries

      if @invites.blank?
        render text: '<html><head><script type="text/javascript">window.top.location.href = '+
            root_url.to_json +
            ';</script></head></html>'
      else
        render 'invites/facebook', layout: false
      end
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
