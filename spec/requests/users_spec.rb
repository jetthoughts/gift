require 'spec_helper'

feature "User sign in and sign up actions" do
  background do
    @user = Fabricate(:user)
    visit root_path
  end

  scenario "Signing in with incorrect credentials" do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'incorrect'
    click_button 'Sign in'

    page.should have_content I18n.t('devise.failure.invalid')
  end

  scenario "Signing up" do
    click_link 'Sign up'
    page.should have_content 'Sign up'
    fill_in 'Name', with: 'Max'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: @user.password
    fill_in 'Password confirmation', with: @user.password
    click_button 'Sign up'

    page.current_path == root_path
    page.should have_content I18n.t('devise.failure.unauthenticated')
  end

  scenario "Signing in with correct credentials without confirmed" do
    pending "Some problem with database cleaner"
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.failure.unconfirmed')
  end

  def sign_in
    @user.update_attribute :confirmed_at, Time.now

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
    page.should have_content 'Listing projects'
  end

  scenario "Signing in with correct credentials and confirmed" do
    sign_in
  end

  scenario "Sign in and sign out" do
    sign_in
    within('ul.nav.pull-right') do
      click_link @user.email
      click_link 'Sign out'
    end
    page.current_path == root_path
  end
end
