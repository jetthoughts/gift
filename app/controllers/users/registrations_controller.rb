class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
  end


  private

  def build_resource(*args)
    super
    puts '*'*100
    resource.invite_token = params[:invite_token]   if params[:invite_token]
  end

end
