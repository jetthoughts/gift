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

  def update
    new_attrs = params[resource_name].reject { |k, v| v.blank? }
    if resource.update_attributes(new_attrs)
      set_flash_message :notice, :updated
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render :edit
    end
  end

  private

  def build_resource(*args)
    super
    resource.invite_token = params[:invite_token] if params[:invite_token]
  end
end
