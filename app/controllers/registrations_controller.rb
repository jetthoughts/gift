class RegistrationsController < Devise::RegistrationsController
  def update
    user = User.find(current_user.id)

    successfully_updated = if @user.provider.present? and !@user.password_changed
                             @user.update_with_password(params[:user])
                           else
                             @user.update_without_password(params[:user])
                           end

    if successfully_updated
      if params[:user][:password].blank?
        @user.update_attribute :password_changed, true 
      end
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end
end
