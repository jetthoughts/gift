require 'spec_helper'

describe Project do
  context "#end_type" do
    it "should be valid if eql to fixed_amount" do
      Fabricate.build(:project, end_type: 'fixed_amount').should_not have(1).errors_on(:end_type)
    end
    it "should be valid if eql to open_end" do
      Fabricate.build(:project, end_type: 'open_end').should_not have(1).errors_on(:end_type)
    end

    it "should be invalid if not inclusion in list" do
      Fabricate.build(:project, end_type: 'invalid_end_type').should_not be_valid
    end

    context "#fixed_amount" do
      it "should be valid if end_type eql to fixed_amount" do
        Fabricate.build(:project, end_type: 'fixed_amount', fixed_amount: 10).should be_valid
      end

      it "should be invalid if not numerical" do
        Fabricate.build(:project, end_type: 'fixed_amount', fixed_amount: 'test').should have(1).errors_on(:fixed_amount)
      end

      it "should be nil if end_type eql to open_end" do
        project = Fabricate.build(:project, end_type: 'open_end', fixed_amount: 10, deadline: DateTime.now.advance(:days => 10))
        project.save
        project.fixed_amount.should be_nil
      end
    end

    context "#open_end" do
      it "should be valid if end_type eql to open_end" do
        Fabricate.build(:project, end_type: 'open_end', deadline: DateTime.now.advance(:days => 10)).should be_valid
      end

      it "should be invalid if not date" do
        expect { Fabricate.build(:project, end_type: 'open_end',  deadline: 'test') }.should raise_error(Mongoid::Errors::InvalidTime)
      end

      it "should be invalid if earlier that now" do
        Fabricate.build(:project, end_type: 'open_end', deadline: DateTime.now - 1.years).should have(1).errors_on(:deadline)
      end

      it "should be nil if end_type eql to fixed_amount" do
        project = Fabricate.build(:project, end_type: 'fixed_amount', fixed_amount: 10, deadline: DateTime.now.advance(:days => 10))
        project.save
        project.open_end.should be_nil
      end
    end
  end
end
