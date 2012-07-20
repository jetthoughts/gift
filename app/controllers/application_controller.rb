class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html
  before_filter :authenticate_user!
  load_and_authorize_resource unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def model_name
    controller_name.classify.parameterize
  end

  def model_params new_params = {}
    params[model_name].merge new_params
  end

end
