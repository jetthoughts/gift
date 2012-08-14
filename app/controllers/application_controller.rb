class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html
  before_filter :authenticate_user!, unless: -> { admin_controller? }
  load_and_authorize_resource unless: -> { devise_controller? || admin_controller? }

  rescue_from CanCan::AccessDenied do |exception|
    logger.debug 'CanCan AccessDenied: ' + exception.message
    redirect_to root_url, alert: exception.message
  end

  private

  def admin_controller?
    self.class.to_s.start_with?('Admin::') || self.class.to_s.start_with?('ActiveAdmin::')
  end

  def model_name
    controller_name.classify.parameterize
  end

  def model_params new_params = {}
    params[model_name].merge new_params
  end
end
