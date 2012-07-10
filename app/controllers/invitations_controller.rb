class InvitationsController < ApplicationController
  def index
    @project = project
  end

  def create

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
