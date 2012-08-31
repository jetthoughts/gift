require 'spec_helper'

describe ProjectsController do
  render_views
  before do
    add_paypal_payment_method
    @user = Fabricate(:user, confirmed_at: Time.now)
    create_project
    sign_in @user
  end

  it 'should dont close project without correct withdraw' do
    post :close, :project_id => @project.id, :format => :js
    @project.reload
    @project.closed?.should be_false
  end

  it 'should close project if withdraw was correct' do
    fee = Fee.new(:amount => 10, :user => @user, :payment_method_id => Paypal::Paypalwp.instance.id)
    fee.user = @user
    fee.project = @project
    fee.purchase
    fee.save!
    @project.fees << fee
    @project.save
    stub_paypal_refund
    post :close, :project_id => @project.id, :format => :js
    @project.reload
    @project.closed?.should be_true
  end

  private

  def stub_paypal_refund
    hello = mock(Object)
    hello.stub!(:success?).and_return(true)
    Paypal::Paypalwp.any_instance.stub(:refund => hello)
  end

  def create_project
    @project = Fabricate(:project_with_amount, admin: @user )
    @project.users << @user
    @project.paid_info = Fabricate.build(:pay_pal_info)
    @project.save
    @user.projects << @project
    @user.save
  end

end
