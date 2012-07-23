class InvitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project, :except => [:destroy]
  before_filter :find_invite, :only => [:show, :update, :destroy]

  def new
    @invites = [@project.invites.build]
  end

  def create
    invite_params = params[:invites]
    return if need_redirect? invite_params

    @invites = []
    invite_params.each do |param|
      name = param[:name]
      email = param[:email]
      invite = @project.invites.create(email: email, name: name)
      @invites.push(invite) if invite.errors.present?
    end

    if @invites.any?
      render :new
      return
    end
    flash[:notice] = 'Success sent'
    redirect_to project_path(@project)
  end

  def create_facebook
    friends = params[:friend_attributes]
    friends.each do |index, user_params|
      user = find_user user_params
      assign_user_to_project user
      @project.invites.create(fb_id: user_params[:friend_uid], name: user_params[:friend_name])
    end

    render nothing: true
  end

  def show
  end

  def update
    @invite.accept!
    redirect_to @project
  end

  def destroy
    @invite.destroy
    redirect_to root_path
  end

  private

  def generate_random_email
    random_string = ''
    email = ''
    begin
      random_string = SecureRandom.hex(10)
      email = random_string + '@test.com'
      logger.debug email
    end until User.where(email: email).first.nil?
    random_string
  end

  def find_user user_params
    user = User.where(uid: user_params[:friend_uid]).first

    if user.nil?
      user = User.new(name: user_params[:friend_name],
                      provider: 'facebook',
                      uid: user_params[:friend_uid],
                      email: generate_random_email,
                      password: 'password',
                      confirmed_at: Time.now,
                      info_uncompleted: true
      )
    end
    user
  end

  def assign_user_to_project user
    user.projects << @project
    user.save!
    @project.users << user
    @project.save!
  end

  def need_redirect? invite_params
    if invite_params.size == 1
      if invite_params[0]['email'].blank? and invite_params[0][:name].blank?
        redirect_to project_path(@project)
        return true
      end
    end
    false
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_invite
    @invite = current_user.invites.find(params[:id])
  end
end