require 'spec_helper'

feature "Comments" do
  include RequestHelper
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
end
