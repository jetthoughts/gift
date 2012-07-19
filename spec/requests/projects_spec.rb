require 'spec_helper'

feature "Project edit" do
  include RequestHelper
  background do
    sign_in
    create_project

    visit root_path
  end

  scenario "with valid attributes" do
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
  include RequestHelper
  background do
    sign_in
    create_project

    visit root_path
  end

  scenario "destroy" do
    page.should have_content "Listing projects"
    page.should have_content "Project Name"

    within '#main tbody tr:nth-child(1)' do
      click_link 'Destroy'
    end
  end
end

feature "Project create and show" do
  include RequestHelper
  background do
    @user = Fabricate(:user)
    visit root_path
  end

  scenario "with valid fixed amount" do
    go_to_new_project

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Earn up to fixed amount')
    find('#project_fixed_amount').should be_visible
    fill_in 'Fixed amount', with: '10'
    choose('Pay pal')
    click_button 'Create Project'

    ##redirect to invites only in success
    page.should have_content 'Invite your Friends'
  end

  scenario "with valid open end" do
    go_to_new_project

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Gather with OpenEnd')

    find('#project_open_end').should be_visible
    fill_in 'Open end', with: (Time.now + 1.months).strftime('%d/%m/%Y %H:%M')
    choose('Pay pal')
    click_button 'Create Project'

    ##redirect to invites only in success
    page.should have_content 'Invite your Friends'
  end

  scenario "with invalid params" do
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
