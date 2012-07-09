require 'spec_helper'
#require 'sign_in_helper'

feature "Comments" do
  include RequestHelpers
  background do
    login
  end

  scenario "Correct sign in" do
    page.should have_content I18n.t('devise.sessions.signed_in')
  end
end
