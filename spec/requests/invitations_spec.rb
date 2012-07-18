require 'spec_helper'

feature "Invitations" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit new_project_invite_path(@project)
  end

  scenario "should has email" do
    page.should have_content 'Send invitation'
    click_button 'Ready'

    page.should have_content "Email can't be blank"
  end

  scenario "should sended" do

    within '#by_email .email_participant:first' do
      fill_in 'invites__name', with: 'Name'
      fill_in 'invites__email', with: 'some@email.com'
    end

    click_button 'Ready'

    current_path.should eql project_path(@project)
    page.should have_content "Success sended"
  end

  scenario 'can add new participant' do
    click_link 'Other participants'
    click_link 'Other participants'

    page.has_selector?('.email_participent', :count => 3)
  end
end