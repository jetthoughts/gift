class ProjectsController < ApplicationController

  has_scope :page, default: 1
  before_filter :find_project, only: [:show, :edit, :update, :destroy]
  before_filter :find_pending_invites, only: :index

  # GET /projects
  def index
    respond_with @projects = scoped_chain.all
  end

  # GET /projects/1
  def show
    @comment = @project.comments.build
    @voted_card = @project.cards.up_voted_by(current_user).first
    respond_with @project
  end

  # GET /projects/new
  def new
    @project = chain.build(end_type: :fixed_amount)
    respond_with @project
  end

  # GET /projects/1/edit
  def edit
    respond_with @project
  end

  # POST /projects
  def create
    @project = current_user.projects.create(model_params(admin: current_user))

    if @project.errors.empty?
      redirect_to [:new, @project, :invite]
    else
      render 'new'
    end
  end

  # PUT /projects/1
  def update
    @project.update_attributes model_params

    respond_with @project
  end

  # POST /projects/1/close
  def close
    @project = chain.find params[:project_id]
    @project.update_attributes closed: true
    @project.run_notify_users_about_close

    flash[:notice] = 'Project closed'
    redirect_to project_path(@project)
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    respond_with @project
  end

  private

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

  def find_project
    @project = chain.find(params[:id])
  end

  def find_pending_invites
    @pending_invites = current_user.pending_invites
  end
end
