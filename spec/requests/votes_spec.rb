require 'spec_helper'

feature "Votes" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit project_path(@project)
  end

  scenario "should likes" do
    add_gift_with_description 'First'
    add_gift_with_description 'Second'

    page.first('.gift').click_button 'Like'

    page.should have_button 'Dislike'
    page.find_button('Like')['disabled'].should eql "disabled"
  end

  scenario "should dislikes" do
     add_gift_with_description 'First'
     add_gift_with_description 'Second'

     page.first('.gift').click_button 'Like'
     click_button 'Dislike'

     page.should_not have_button 'Dislike'
     page.find_button('Like')['disabled'].should_not eql "disabled"
   end

  def add_gift_with_description description
    click_link 'Add gift suggestion'

    fill_in 'Description', with: description
    page.attach_file('card_image', Rails.root.join('spec', 'assets', 'test-image.jpg'))
    click_button 'Add gift'

    page.should have_content description
  end
end