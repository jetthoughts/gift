require 'spec_helper'

describe Card do
  it { should validate_presence_of(:image) }
end
