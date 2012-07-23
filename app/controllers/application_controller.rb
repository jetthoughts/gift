class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html
  before_filter :logged_in
  load_and_authorize_resource unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug 'CanCan AccessDenied: ' + exception.message
    redirect_to root_url, alert: exception.message
  end

  def model_name
    controller_name.classify.parameterize
  end

  def model_params new_params = {}
    params[model_name].merge new_params
  end

  private

  def logged_in
    return if params[:user].blank?

    user = User.where(email: params[:user][:email]).first

    if user.info_uncompleted
      redirect_to root_url, alert: 'Access Denied'
      return
    end
    authenticate_user!
  end

end
