require 'spec_helper'

feature "Cards" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit project_path(@project)
  end

  scenario "should not be created without image" do
    click_link 'Add gift suggestion'
    click_button 'Add gift'

    page.should have_content "Image can't be blank"
  end

  scenario "should be created successfully with correct params" do
    click_link 'Add gift suggestion'

    fill_in 'Description', with: 'description'
    page.attach_file('card_image', Rails.root.join('spec', 'assets', 'test-image.jpg'))
    click_button 'Add gift'

    within('.gift') { page.should have_content 'description' }
  end
end
