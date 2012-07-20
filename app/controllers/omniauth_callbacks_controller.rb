class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(auth, current_user)

    if @user.persisted?
      @user.fbook_access_token = (credentials = auth["credentials"]) ? credentials["token"] : nil
      @user.save!
      @user.check_invite_token

      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end