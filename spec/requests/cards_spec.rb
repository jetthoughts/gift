require 'spec_helper'

feature "Cards" do
  include RequestHelper
  background do
    sign_in
  end

  scenario "add gift without image" do
    create_project

    page.should have_link 'Add gift suggestion'
    click_link 'Add gift suggestion'
    click_button 'Add gift'

    page.should have_content "Image can't be blank"
  end

  scenario "add gift" do
     create_project

     page.should have_link 'Add gift suggestion'
     click_link 'Add gift suggestion'

     fill_in 'Description', 'description'
     page.attach_file('#card_image', '/images/test-image.jpg')
     click_button 'Add gift'

     page.should have_content "'description'"
   end
end
