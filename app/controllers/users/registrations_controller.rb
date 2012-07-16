class Users::RegistrationsController < Devise::RegistrationsController

  def new
    atrs = {}
    if params[:invite_token] and invite = Invite.where(:invite_token => params[:invite_token]).first
      atrs = {:email => invite.email, :name => invite.name}
    end
    resource = build_resource(atrs)
    respond_with resource
  end

  def create
    super
  end

  private

  def build_resource(*args)
    super
    resource.invite_token = params[:invite_token]   if params[:invite_token]
  end

end
