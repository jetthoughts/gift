require 'spec_helper'

describe InvitesMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ::Rails.application.routes.url_helpers

  describe 'for new user' do
    subject do
      user = Fabricate(:user)
      project = Fabricate(:project_with_amount, admin: user)
      invite = Fabricate.build(:invite, user: user, project: project, invite_token: 'secret_token', name: 'foo bar', email: 'test@test.com')
      InvitesMailer.new_user_notify(invite)
    end

    it "should contain correct body and subject" do
      should have_body_text(/Someone has invited you/)
      should have_subject('Invite you to new project')
    end

    it 'should have correct invite token' do
      should have_body_text(/invite_token=secret_token/)
    end

    it 'should have correct name and email' do
      should deliver_to('test@test.com')
      should have_body_text(/Hello, foo bar!/)
    end
  end

  describe 'for exist user' do
    subject do
      user = Fabricate(:user, name: 'foo bar', email: 'test@test.com')
      project = Fabricate(:project_with_amount, admin: user)
      @invite = Fabricate(:invite, user: user, project: project, name: 'foo bar', email: 'test@test.com')
      InvitesMailer.exist_user_notify(@invite)
    end

    it "should contain correct body and subject" do
      should have_body_text(/Someone has invited you/)
      should have_subject('Invite you to new project')
    end

    it 'should have correct project link' do
      #should have_body_text(/#{project_invite_url(@invite.project, @invite)}/)
    end

    it 'should have correct name and email' do
      should deliver_to('test@test.com')
      should have_body_text(/Hello, foo bar!/)
    end
  end


end