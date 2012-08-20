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
    page.should have_content "Name can't be blank"
  end

  scenario "should be created successfully with correct params" do
    click_link 'Add gift suggestion'

    fill_in 'Name', with: 'name'
    fill_in 'Description', with: 'description'
    page.attach_file('card_image', Rails.root.join('spec', 'assets', 'test-image.jpg'))
    click_button 'Add gift'

    within('.gift') do
      page.should have_content 'description'
      page.should have_content 'name'
    end
  end
end

feature "Gift from Amazon Advertising API" do
  include RequestHelper

  background do
    sign_in
    create_project
    visit project_path(@project)
  end

  scenario "should not add gift from not amazon link" do
    click_link 'Add gift suggestion'
    fill_in 'Web link', with: 'http://google.com'
    wait_until 5
    field_labeled('Name').value.should be_blank
  end

  scenario "should add gift from amazon link", vcr: true, js: true do
    click_link 'Add gift suggestion'
    fill_in 'Web link', with: 'http://www.amazon.com/gp/product/B0050SBGRS'
    wait_until { find('#choose_image').visible? }
    within('#choose_image') { click_link 'Close'}

    within '#new_card' do
      field_labeled(' Name').value.should eql "Citizen Men's AT1180-05E Chronograph Eco Drive Watch"
      field_labeled('Description').value.should eql 'Watch'
      field_labeled('Price').value.should eql '299.00'

      find('#select_other_image').should be_visible


      field_labeled('Remote image url').value.should eql 'http://ecx.images-amazon.com/images/I/516fblWcHZL.jpg'

      click_button 'Add gift'
    end

    within '.gift' do
      page.should have_content 'Citizen Men'
      page.should have_content 'Watch'
    end
  end

  scenario "should add gift from amazon search", vcr: true, js: true do
    click_link 'Add gift suggestion'
    click_link 'Amazon search'
    find('#search_modal').should be_visible

    within('#search_modal') do
      fill_in 'q', with: 'rspec book'
      click_button 'Search'
      wait_until { find('.modal-body .items').visible? }
      find('.add-gift').click
    end

    wait_until { find('#choose_image').visible? }
    within('#choose_image') { click_link 'Close'}
    page.should have_css '#search_modal .add-gift.btn-danger'
    within('#search_modal') { click_link 'Close'}

    within '#new_card' do
      field_labeled(' Name').value.should eql "The RSpec Book: Behaviour Driven Development with Rspec, Cucumber, and Friends (The Facets of Ruby Series)"
      field_labeled('Description').value.should eql 'Book'
      field_labeled('Price').value.should eql '38.95'

      find('#select_other_image').should be_visible


      field_labeled('Remote image url').value.should eql 'http://ecx.images-amazon.com/images/I/51tFzC0fFZL.jpg'

      click_button 'Add gift'
    end

    within '.gift' do
      page.should have_content 'RSpec Book'
      page.should have_content 'Book'
    end



  end
end
