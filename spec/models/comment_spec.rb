require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:text) }


  describe 'Notification' do
    before do
      @user = Fabricate(:user)
      @user2 = Fabricate(:user, notification_new_comment: true)
      @user3 = Fabricate(:user, notification_new_comment: false)
      @project = Fabricate(:project_with_amount, admin: @user, users: [@user, @user2, @user3])

    end

    it 'should include users except owner with enable notification setting' do
      comment = @project.comments.build(:user => @user, :text => 'text')
      comment.recipients.count.should eql(1)
      comment.recipients.first.should eql(@user2)
    end

  end
end
