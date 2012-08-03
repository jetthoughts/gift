require 'spec_helper'

feature "Project edit" do
  include RequestHelper
  background do
    sign_in
    create_project

    visit root_path
  end

  scenario "with valid attributes" do
    click_link 'Edit'

    page.should have_content 'Editing project'

    fill_in 'Name', with: "New name"
    click_button 'Update Project'

    current_path.should eql project_path(@project)
    page.should have_content 'New name'
  end

  scenario 'close dialog contains little withdraw text', js: true do
    click_link 'Show'
    click_link 'Close project'

    page.should have_content 'Too little collected for withdraw.'
    page.should have_button 'OK'

    click_button 'OK'
    current_path.should eql project_path(@project)
  end

  scenario 'close dialog with fee but without paid info should be redirect to edit page', js: true do
    add_payment_method
    Fabricate(:fee, user: @user, project: @project, payment_method: PaymentMethod.first)

    click_link 'Show'
    page.should have_content '20.00 donations'
    click_link 'Close project'

    page.should have_content 'You must input your paid type info in the edit project page and try later'

    click_button 'OK'
    page.should have_content 'Editing project'
  end

  scenario 'close dialog with fee and paid info should be close project', js: true do
    add_payment_method
    Fabricate(:fee, user: @user, project: @project, payment_method: PaymentMethod.first)
    @project.paid_info = Fabricate.build(:pay_pal_info)
    @project.save

    click_link 'Show'
    page.should have_content '20.00 donations'
    click_link 'Close project'

    page.should have_content '20.00 will be transferred to the paypal account'

    click_button 'Close'
    page.should have_content 'Project closed'
  end

end

feature "Project create and show" do
  include RequestHelper
  background do
    @user = Fabricate(:user)
    visit root_path
  end

  scenario "with valid fixed amount" do
    go_to_new_project

    fill_in 'Name', with: 'Test Project'
    fill_in 'Description', with: 'Project Description'
    fill_in 'Article link', with: 'http://google.com'
    choose('Earn up to fixed amount')
    find('#project_fixed_amount').should be_visible
    fill_in 'Fixed amount', with: '10'
    fill_in 'Deadline', with: (Time.now + 1.months).strftime('%d/%m/%Y %H:%M')
    choose('Pay pal')
    click_button 'Create Project'

    ##redirect to invites only in success
    page.should have_content 'Invite your Friends'
  end

  scenario "with invalid params" do
    go_to_new_project

    click_button 'Create Project'

    page.should have_content "Some errors were found, please take a look:"
    page.should have_content "can't be blank"
  end
end

def go_to_new_project
  sign_in
  click_link 'New Project'
  page.should have_content 'New project'
end
