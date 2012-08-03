require 'spec_helper'

feature "Fees page" do
  include RequestHelper
  background do
    sign_in
    create_project
    visit project_path(@project)
  end

  scenario 'should show errors in incorrect' do
    click_link 'Engage'
    page.should have_content 'How do you want to contribute?'

    click_button 'Next'
    page.should have_content 'Some errors were found, please take a look:'
    page.should have_content "Payment method can't be blank"
    page.should have_content "Amount can't be blank"
  end

  scenario 'test credit card dialog', js: true do
    add_payment_method

    click_link 'Engage'
    page.should have_content 'CreditCard'

    fill_in 'fee_amount', with: 20
    choose('CreditCard')

    click_button 'Next'
    page.should have_button 'Submit'

    fill_in 'creditcard_name', with: 'Test Test'
    fill_in 'creditcard_number', with: '4007000000027'
    fill_in 'creditcard_cvv', with: '123'
    select '2015', :from => 'creditcard_expires_on_1i'

    click_button 'Submit'
    current_path.should eql project_path(@project)
    page.should have_content '20.00 donations'
  end
end