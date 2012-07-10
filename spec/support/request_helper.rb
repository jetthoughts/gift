module RequestHelper
  def sign_in
    @user = Fabricate(:user)
    @user.update_attribute :confirmed_at, Time.now
    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
    page.should have_content 'Listing projects'
  end

  def create_project
    click_link 'New Project'

    page.should have_content 'New project'

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Earn up to fixed amount')

    find('#project_fixed_amount').should be_visible

    fill_in 'Fixed amount', with: '10'
    choose('Pay pal')

    should_create_valid_project
  end

  def should_create_valid_project
    click_button 'Create Project'

    page.should have_content 'Test Project'
    page.should have_content 'Project Description'
    page.should have_link 'Profile'
    page.should have_link 'Edit project'
  end
end