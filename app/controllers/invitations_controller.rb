class InvitationsController < Devise::InvitationsController
  before_filter :authenticate_user!

  def new
    super
  end

  def create
    p '#' * 20
    @project = project
    @user = current_user
    invite_params = params[:user][:name].zip params[:user][:email]

    invite_params.each do |param|
      name, email = param
      if name.blank? || email.blank?
        next
      end
      @invite = User.invite!({name: name, email: email}, @user)

      if @invite.errors
        render :new
        return
      end
    end

    redirect_to project_path @project
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