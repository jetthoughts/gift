class ProjectsController < ApplicationController
  has_scope :page, default: 1

  # GET /projects
  def index
    respond_with @projects = scoped_chain.all
  end

  # GET /projects/1
  def show
    @project = chain.find(params[:id])
    @comment = @project.comments.build
    @voted_card = @project.cards.up_voted_by(current_user).first
    respond_with @project
  end

  # GET /projects/new
  def new
    respond_with @project = chain.build(end_type: :fixed_amount)
  end

  # GET /projects/1/edit
  def edit
    respond_with @project = chain.find(params[:id])
  end

  # POST /projects
  def create
    respond_with @project = chain.create(project_params(user: current_user))
  end

  # PUT /projects/1
  def update
    @project = chain.find params[:id]
    @project.update_attributes project_params

    respond_with @project
  end

  # DELETE /projects/1
  def destroy
    @project = chain.find(params[:id])
    @project.destroy
    respond_with @project
  end

  private

  def project_params new_params = {}
    params[:project].merge new_params
  end

  def owner
    @owner ||= current_user
  end

  def projects_chain
    @rojects_chain ||= (owner and owner.projects) or Project
  end

  def chain
    projects_chain.ordered_by_date
  end

  def scoped_chain
    apply_scopes chain
  end
end
