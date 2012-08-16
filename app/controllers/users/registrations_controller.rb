class Users::RegistrationsController < Devise::RegistrationsController

  def new
    atrs = {}
    puts '*'*100
    if params[:invite_token] and invite = Invite.where(:invite_token => params[:invite_token]).first
      puts '*'*100
      p invite
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
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    if resource.update_attributes(new_attrs)
      flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
      set_flash_message :notice, flash_key
      redirect_to after_update_path_for(resource)
    else
      render :edit
    end
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end
  
  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous.present? &&
      previous != resource.unconfirmed_email
  end

  def build_resource(*args)
    super
    resource.invite_token = params[:invite_token] if params[:invite_token]
  end
end
