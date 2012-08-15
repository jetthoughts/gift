class InvitesController < ApplicationController
  before_filter :find_project, :except => [:destroy]
  before_filter :find_invite, :only => [:show, :update, :destroy, :facebook_update, :facebook_destroy]
  skip_load_and_authorize_resource
  load_and_authorize_resource

  def new
    @invites = [@project.invites.build]
    @phone_invites = [@project.invites.build]
  end

  def create
    invite_params = params[:invites].reject {|invite| invite[:email].blank? and invite[:phone].blank? and invite[:name].blank? }
    if invite_params.any?
      @invites, @phone_invites = [], []
      invite_params.each do |param|
        name, email, phone = param[:name], param[:email], param[:phone]
        invite = @project.invites.create(phone: phone, email: email, name: name, creator_name: current_user.name)
        (param.has_key?(:phone) ? @phone_invites : @invites).push(invite) if invite.errors.present?
      end

      if @invites.any? || @phone_invites.any?
        render :new
        return
      end
      flash[:notice] = 'Success sent'
    end
    redirect_to project_path(@project)
  end

  def create_facebook
    friends = params[:friend_attributes]
    friends.each do |index, user_params|
      @project.invites.create(fb_id: user_params[:friend_uid], name: user_params[:friend_name], creator_name: current_user.name)
    end

    render nothing: true
  end

  def show
  end

  def facebook_update
    @invite.accept!
    redirect_to :back
  end

  def facebook_destroy
    @invite.destroy
    redirect_to :back
  end

  def update
    @invite.user ||= current_user

    @invite.accept!
    redirect_to @project
  end

  def destroy
    @invite.destroy
    redirect_to root_path
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_invite
    #@invite = current_user.invites.for_ids(params[:id]).first
    @invite = Invite.find(params[:id])
  end
end