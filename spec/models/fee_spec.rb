require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))
describe Fee do

  before do
    @user = Fabricate(:user)
    @project = Fabricate(:project_with_amount, admin: @user)
    Paypal::Paypalwp.create!(
          {
              name: 'Paypal website payments standard',
              permalink: 'paypalwp',
              description: %Q[<p> Paypal website payments standard is a payment solution provided by paypal which allows merchant to accept credit card and paypal payments.  There is no monthly fee and no setup fee by paypal for this account.  </p> <p> <a href='https://merchant.paypal.com/cgi-bin/marketingweb?cmd=_render-content&content_ID=merchant/wp_standard&nav=2.1.0'> more information </a> </p>]
          })
  end

  describe 'Validation' do
      it 'should contain payment_method' do
        fee = @user.fees.build(project: @project)
        fee.valid?.should be_false
      end

      it 'should contain paypal payment_method' do
        fee = @user.fees.build(project: @project, payment_method_id: Paypal::Paypalwp.instance.id, amount: 10)
        fee.valid?.should be_true
      end

  end

end
