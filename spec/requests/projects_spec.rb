require 'spec_helper'

feature "Project create and show" do
  include RequestHelper
  background do
    sign_in
  end

  scenario "Create project with valid fixed amount" do
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

  scenario "Create project with valid open end" do
    click_link 'New Project'

    page.should have_content 'New project'

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Gather with OpenEnd')

    find('#project_open_end').should be_visible
    fill_in 'Open end', with: (Time.now + 1.months).strftime('%d/%m/%Y %H:%M')
    choose('Pay pal')

    should_create_valid_project
  end
end
