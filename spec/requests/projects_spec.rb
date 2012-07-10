require 'spec_helper'

feature "Project edit" do
  background do
    @user = Fabricate(:user)
    @project = Fabricate(:project, name: 'Project Name', end_type: :fixed_amount, fixed_amount: 10, user: @user)
    @project.save

    visit root_path
  end

  scenario "with valid attributes" do
    sign_in

    visit root_path

    page.should have_content "Listing projects"
    page.should have_content "Project Name"

    within '#main tbody tr:nth-child(1)' do
      click_link 'Edit'
    end

    page.should have_content 'Editing project'

    fill_in 'Name', with: "New name"
    click_button 'Update Project'

    current_path.should eql project_path(@project)
    page.should have_content 'New name'
  end

end

feature "Project destroy" do
  background do
    @user = Fabricate(:user)
    @project = Fabricate(:project, name: 'Project Name', end_type: :fixed_amount, fixed_amount: 10, user: @user).save

    visit root_path
  end

  scenario "destroy" do
    sign_in

    page.should have_content "Listing projects"
    page.should have_content "Project Name"

    within '#main tbody tr:nth-child(1)' do
      click_link 'Destroy'
    end



  end
end

feature "Project create and show" do
  background do
    @user = Fabricate(:user)
    visit root_path
  end

  scenario "Create project with valid fixed amount" do
    go_to_new_project

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
    go_to_new_project

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

  scenario "Create project with invalid params" do
    go_to_new_project

    click_button 'Create Project'

    page.should have_content "Some errors were found, please take a look:"
    page.should have_content "can't be blank"
  end
end

def go_to_new_project
  sign_in
  click_link 'New Project'
  page.should have_content 'New project'
end

def sign_in
  @user.update_attribute :confirmed_at, Time.now

  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign in'

  page.should have_content I18n.t('devise.sessions.signed_in')
  page.should have_content 'Listing projects'
end
