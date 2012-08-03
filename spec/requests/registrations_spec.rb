require 'spec_helper'

feature "User edit profile action" do
  background do
    @user = Fabricate(:user, password: 'qweqwe')
    visit root_path
  end

  scenario "Open edit profile page" do
    sign_in
    within 'ul.nav.pull-right' do
      click_link @user.email
      click_link 'Profile'
    end
    current_path.should eql edit_user_registration_path
    page.should have_content 'Profile'
  end

  scenario "Update profile" do
    sign_in
    visit edit_user_registration_path
    fill_in 'Name', with: 'New Name'
    click_button 'Update'

    page.should have_content I18n.t('devise.registrations.updated')
  end

  scenario "Update email" do
    sign_in
    visit edit_user_registration_path
    fill_in 'Email', with: 'test@mailer.com'
    click_button 'Update'

    page.should have_content I18n.t('devise.registrations.updated')
  end

  scenario "Set new password without current_password" do
    sign_in
    visit edit_user_registration_path
    fill_in 'Password', with: 'new_password'
    fill_in 'Password confirmation', with: 'new_password'
    click_button 'Change password'

    page.should have_content I18n.t('simple_form.error_notification.default_message')
    within 'div.password.error' do
      page.should have_content "can't be blank"
    end
  end

  def sign_in
    @user.update_attribute :confirmed_at, Time.now

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
  end

end
