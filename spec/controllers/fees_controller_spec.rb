require 'spec_helper'

describe FeesController do
  # render_views
  before do
    add_paypal_payment_method
    @user = Fabricate(:user, confirmed_at: Time.now)
    create_project
    sign_in @user
  end

  context '#new' do
    before do
      @fee = Fabricate(:fee, project_id: @project.id)
      @project.fees.stub(:build).return(@fee)
    end

    it "should build new fee" do
      @project.fees.should_receive(:build).and_return(@fee)
      get :new, project_id: @project.id 
    end
  end

  context '#create' do
    it "should render new without params" do
      post :create, project_id: @project.id, fee:{}
      response.should render_template('new')
    end

    it "should redirect to paypal" do
      fee_options = {
        amount: 4,
        payment_method_id: PaymentMethod.first.id,
        visible: true
      }
      post :crate, project_id: @project.id, fee: fee_options
    end
  end

  private

  def create_project
    @project = Fabricate(:project_with_amount, admin: @user )
    @project.users << @user
    @project.paid_info = Fabricate.build(:pay_pal_info)
    @project.save
    @user.projects << @project
    @user.save
  end
end
