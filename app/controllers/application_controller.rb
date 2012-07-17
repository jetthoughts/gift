class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  respond_to :html


  def access_denied
    raise 'Access denied'
  end

  def model_name
    controller_name.classify.parameterize
  end

  def model_params new_params = {}
    params[model_name].merge new_params
  end

end
