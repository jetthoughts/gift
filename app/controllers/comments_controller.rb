class CommentsController < ApplicationController
  def index
    respond_with project, @comments = chain.all
  end

  def create
    respond_with project, @comment = chain.create(comment_params.merge({user: current_user}))
  end

  def update
    respond_with project, @comment = chain.update(params[:id], comment_params)
  end

  def destroy
    respond_with project, @comment = chain.destroy(params[:id])
  end

  private

  def comment_params
    params[:comment].merge user: current_user
  end

  def chain
    project.comments
  end

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