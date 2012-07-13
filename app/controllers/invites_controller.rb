class InvitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project

  def new
    @invite = @project.invites.build
  end

  def create
    invite_params = params[:user][:name].zip params[:user][:email]

    invite_params.each do |param|
      name, email = param
      @invite = @project.invites.create(email: email, name: name)
      if @invite.errors.present?
        render :new
        return
      end
    end

    flash[:notice] =  'Success sended'
    redirect_to project_path(@project)
  end

  def edit
    super
  end

  def update
    super
  end

  private

  def find_project
    @project  = Project.find(params[:project_id])
  end
end