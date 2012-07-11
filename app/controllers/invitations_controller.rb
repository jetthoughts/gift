class InvitationsController < Devise::InvitationsController
  before_filter :authenticate_user!

  def new
    super
  end

  def create
    #User.invite! email: "new_user@example.com", invited_by: current_user
    super
  end

  def edit
    super
  end

  def update
    super
  end

  private

  def project
    Project.find(params[:project_id])
  end
end