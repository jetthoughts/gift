require 'spec_helper'

describe ProjectsController do
  include RequestHelper
  before do
    create_project
    sign_in @project.admin
  end

  it 'should dont close project without correct withdraw' do
    post :close, :project_id => @project.id
    @project.reload
    @project.closed?.should be_false
  end

end
