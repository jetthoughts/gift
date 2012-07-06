require 'spec_helper'

feature "Project create and show" do
  background do
    @user = Fabricate(:user)
    visit root_path
  end

  scenario "Create project with valid fixed amount" do
    sign_in

    click_link 'New Project'

    page.should have_content 'New project'

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Earn up to fixed amount')
    find('#project_fixed_amount').should be_visible
    fill_in 'Fixed amount', with: '10'
    choose('Pay pal')
    click_button 'Create Project'

    page.should have_content 'Test Project'
    page.should have_content 'Project Description'
    page.should have_link 'Profile'
    page.should have_link 'Edit project'
  end

  scenario "Create project with valid open end" do
    sign_in

    click_link 'New Project'

    page.should have_content 'New project'

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Gather with OpenEnd')
    find('#project_open_end').should be_visible
    fill_in 'Open end', with: (Time.now + 1.months).strftime('%d/%m/%Y %H:%M')
    choose('Pay pal')
    click_button 'Create Project'

    page.should have_content 'Test Project'
    page.should have_content 'Project Description'
    page.should have_link 'Profile'
    page.should have_link 'Edit project'
  end


  def sign_in
    @user.update_attribute :confirmed_at, Time.now

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
    page.should have_content 'Listing projects'
  end
end
