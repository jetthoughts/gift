class ProjectsController < ApplicationController
  has_scope :page, default: 1
  before_filter :find_project, only: [:show, :edit, :update, :destroy]
  before_filter :check_rights, only: [:edit, :update, :destroy]
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
    respond_with @project = chain.build(end_type: :fixed_amount)
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

  def check_rights
    access_denied unless @project.can_manage?(current_user)
  end

end
