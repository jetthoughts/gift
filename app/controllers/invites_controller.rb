class InvitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project, :except => [:destroy]
  before_filter :find_invite, :only => [:show, :update, :destroy]

  def new
    @invites = [@project.invites.build]
  end

  def create
    invite_params = params[:invites]
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
    flash[:notice] =  'Success sent'
    redirect_to project_path(@project)
  end

  def show
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

  def find_project
    @project  = Project.find(params[:project_id])
  end

  def find_invite
    @invite = current_user.invites.find(params[:id])
  end

end