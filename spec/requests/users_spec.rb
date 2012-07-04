require 'spec_helper'

feature "User sign in and sign up actions" do
  background do
    #user = Fabricator(:user, email: 'test@test.com', password: 'qweqwe')
    visit root_path
  end

  scenario "Signing in with incorrect credentials" do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: 'incorrect'
    click_button 'Sign in'

    page.should have_content 'Invalid email or password'
  end

  scenario "Signing up" do
      click_link 'Sign up'
      page.should have_content 'Sign up'

      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'qweqwe'
      fill_in 'Password confirmation', with: 'qweqwe'
      click_button 'Sign up'

      page.current_path == root_path
      page.should have_content 'You need to sign in or sign up before continuing.'

  end
end