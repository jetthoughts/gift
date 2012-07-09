module RequestHelpers
  def sign_in
    @user = Fabricate(:user)
    @user.update_attribute :confirmed_at, Time.now
    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'

    page.should have_content I18n.t('devise.sessions.signed_in')
    page.should have_content 'Listing projects'
  end
end