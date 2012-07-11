class InvitationsController < Devise::InvitationsController
  def new
    #@project = project
    p '################################'
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  private

  def author
    @author ||= params[:user_id] ? User.find(params[:user_id]) : nil
  end

  def projects_chain
    @projects_chain ||= (author and author.projects) or Project
  end

  def project
    projects_chain.find(params[:project_id])
  end
end