require 'spec_helper'

feature "Signing up" do
  background do
    @user = Fabricator(:user, email: 'test@test.com', password: 'qweqwe')
  end

  scenario "Signing in with incorrect credentials" do
    visit root_path

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'incorrect'
    click_button 'Sign in'

    page.should have_content 'Invalid email or password'
  end
end