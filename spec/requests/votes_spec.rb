require 'spec_helper'

feature "Votes" do
  include RequestHelper
  background do
    sign_in
  end

  scenario "should likes and dislikes" do
    create_project

    add_gift_with_description 'First'
    add_gift_with_description 'Second'

    page.first('.gift').click_button 'Like'

    page.should have_button 'Dislike'
    page.find_button('Like')['disabled'].should == "disabled"
  end

  def add_gift_with_description description
    page.should have_link 'Add gift suggestion'
    click_link 'Add gift suggestion'

    fill_in 'Description', with: description
    page.attach_file('card_image', Rails.root.join('spec', 'assets', 'test-image.jpg'))
    click_button 'Add gift'

    page.should have_content description
  end
end