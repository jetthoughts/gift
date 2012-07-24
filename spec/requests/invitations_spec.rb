require 'spec_helper'

feature "Invitations" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit new_project_invite_path(@project)
  end

  scenario "should has email" do
    page.should have_content 'Invite your Friends'
    click_button 'Ready'

    current_path.should eql project_path(@project)
  end

  scenario "should sent" do
    within '#by_email .email_participant:first' do
      fill_in 'invites__name', with: 'Name'
      fill_in 'invites__email', with: 'some@email.com'
    end

    click_button 'Ready'

    current_path.should eql project_path(@project)
    page.should have_content "Success sent"
  end

  scenario 'can add new participant' do
    click_link 'Other participants'
    click_link 'Other participants'

    page.has_selector?('.email_participant', :count => 3)
    page.has_selector?('.remove_email_participant', :count => 2)
  end

  scenario 'can remove participient' do
    click_link 'Other participants'
    page.has_selector?('.email_participant', :count => 2)

    click_link 'remove'
    page.has_selector?('.email_participant', :count => 1)
  end
end