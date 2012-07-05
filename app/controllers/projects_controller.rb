class ProjectsController < ApplicationController
  has_scope :page, default: 1

  # GET /projects
  # GET /projects.json
  def index
    respond_with @projects = scoped_chain.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = chain.find(params[:id])
    @comment = @project.comments.build
    respond_with @project
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    respond_with @project = chain.new
  end

  # GET /projects/1/edit
  def edit
    respond_with @project = chain.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    respond_with @project = chain.create(project_params(user: current_user))
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    respond_with @project = chain.update(params[:id], project_params)
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    respond_with @project = chain.destroy(params[:id])
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
