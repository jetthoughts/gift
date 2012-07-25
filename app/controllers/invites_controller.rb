class InvitesController < ApplicationController
  before_filter :find_project, :except => [:destroy]
  before_filter :find_invite, :only => [:show, :update, :destroy, :facebook_update, :facebook_destroy]

  def new
    @invites = [@project.invites.build]
  end

  def create
    invite_params = params[:invites]
    return if need_redirect? invite_params

    @invites = []
    invite_params.each do |param|
      name = param[:name]
      email = param[:email]
      invite = @project.invites.create(email: email, name: name)
      @invites.push(invite) if invite.errors.present?
    end

    if @invites.any?
      render :new
      return
    end
    flash[:notice] = 'Success sent'
    redirect_to project_path(@project)
  end

  def create_facebook
    friends = params[:friend_attributes]
    friends.each do |index, user_params|
      @project.invites.create(fb_id: user_params[:friend_uid], name: user_params[:friend_name])
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
    @invite.accept!
    redirect_to @project
  end

  def destroy
    @invite.destroy
    redirect_to root_path
  end

  private

  def need_redirect? invite_params
    if invite_params.size == 1
      if invite_params[0]['email'].blank? and invite_params[0][:name].blank?
        redirect_to project_path(@project)
        return true
      end
    end
    false
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_invite
    @invite = current_user.invites.find(params[:id])
  end
end