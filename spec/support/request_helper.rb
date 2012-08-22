module RequestHelper
  def sign_in
    @user = Fabricate(:user, confirmed_at: Time.now)
    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
  end

  def create_project
    @project = Fabricate(:project_with_amount, admin: @user)
    @project.users << @user
    @project.save
    @user.projects << @project
    @user.save
  end

  def add_payment_method
    task_1 = 'authorizedotnet:load_record'
    task_2 = 'paypal:load_record'
    require 'rake'
    rake = Rake::Application.new
    Rake.application = rake
    Rake::Task.define_task(:environment)
    load "gems/nimbleshop_authorizedotnet-0.0.5/lib/tasks/authorize.rake"
    load "tasks/paypal_tasks.rake"
    rake[task_1].invoke
    rake[task_2].invoke
  end
end
