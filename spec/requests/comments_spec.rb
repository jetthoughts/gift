require 'spec_helper'
#require 'sign_in_helper'

feature "Comments" do
  include RequestHelpers
  background do
    sign_in
  end

  scenario "add my comment" do
    create_project
    page.should have_button 'Add comment'

    within('.new_comment') do
      fill_in 'Text', :with => 'My comment'
      click_button 'Add comment'
      fill_in 'Text', :with => ''
    end

    page.should have_content 'My comment'
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
    click_button 'Create Project'
  end
end
