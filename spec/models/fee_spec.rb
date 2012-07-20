require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
describe Fee do

  before do
    @user = Fabricate(:user)
    @project = Fabricate(:project_with_amount, admin: @user)
  end

  describe 'Falidation' do
      it 'should contain payment_method' do
        fee = @user.fees.build(project: @project)
        fee.valid?.should be_false
      end

      it 'should contain paypal payment_method' do
        fee = @user.fees.build(project: @project, payment_method: 'paypal')
        fee.valid?.should be_true
      end

      it 'should requests credit_card to be valid' do
        fee = @user.fees.build(project: @project, payment_method: 'cc')
        fee.valid?.should be_false
      end

  end

end
