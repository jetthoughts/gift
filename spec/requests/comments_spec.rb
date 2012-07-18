require 'spec_helper'

feature "Comments" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit project_path(@project)
  end

  scenario "add my comment" do
    page.should have_button 'Add comment'

    within('.new_comment') do
      fill_in 'Text', :with => 'My comment'
      click_button 'Add comment'
    end

    page.should have_content 'My comment'
  end
end
