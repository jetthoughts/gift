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

  def profile
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    new_attrs = params[resource_name]
    if resource.update_attributes(new_attrs)
      set_flash_message :notice, :updated
      redirect_to after_update_path_for(resource)
    else
      render :edit
    end
  end

  private

  def build_resource(*args)
    super
    resource.invite_token = params[:invite_token] if params[:invite_token]
  end
end
