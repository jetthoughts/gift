require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should validate_presence_of(:password) }

  describe 'abilities' do
    subject { ability }
    let(:ability) { Ability.new(user)}

    context "when is an guest" do
      let(:user) { nil }

      it { should be_able_to :create, User }
      it { should_not be_able_to :manage, [Project, Comment, Invite, Card] }
    end

    context "when is a" do
      let(:user)    { Fabricate(:user) }
      let(:project) { Fabricate(:project_with_amount, admin: user) }

      context "valid user" do
        let(:comment) { Fabricate(:comment, user: user) }
        let(:invite)  { Fabricate(:invite, user: user, project: project) }


        it { should be_able_to :create,  Invite  }
        it { should be_able_to :update,  invite  }
        it { should be_able_to :destroy, invite  }
        it { should be_able_to :create,  Project }
        it { should be_able_to :manage,  comment }
        it { should be_able_to :manage,     user }
      end

      context "admin of project" do
        let(:project) { Fabricate(:project_with_amount, admin: user) }

        it { should be_able_to :manage, project }
        it { should be_able_to :close,  project }
      end

      context "participant of project" do
        let(:project) { Fabricate(:project_with_amount, participants_add_own_suggestions: false) }

        before { project.users << user; project.save }

        it { should_not be_able_to :manage, project }
        it { should     be_able_to :create, project.comments.build }
        it { should_not be_able_to :create, project.cards.build }
        it { should     be_able_to :update, project.cards.build }
      end

      context "partisipant of project with ability to add own suggestios" do
        let(:project) { Fabricate(:project_with_amount, participants_add_own_suggestions: true) }

        before { project.users << user; project.save }

        it { should_not be_able_to :manage, project }
        it { should     be_able_to :create, project.comments.build }
        it { should     be_able_to :create, project.cards.build }
        it { should     be_able_to :update, project.cards.build }
      end
    end
  end
end
