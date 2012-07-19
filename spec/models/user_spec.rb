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

      it { should be_able_to(:create, User) }
      it { should_not be_able_to(:show, [Project, Comment, Invite, Card]) }
    end
  end
end
