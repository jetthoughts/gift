require 'spec_helper'

describe UsersController do
  describe "GET show" do
    it "assigns the requested user as @user" do
      user = Fabricate(:user)
      sign_in user

      get :show

      assigns(:user).should eq(user)
    end
  end
end
