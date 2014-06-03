require 'spec_helper'

module ProcessAllocx
  describe Allocation do
    it "should be OK" do
      c = FactoryGirl.build(:process_allocx_allocation)
      c.should be_valid
    end

    it "should take 0 operator_id" do
      c = FactoryGirl.build(:process_allocx_allocation, :operator_id => 0)
      c.should_not be_valid
    end

    it "should reject nil alloc_category" do
      c = FactoryGirl.build(:process_allocx_allocation, :allocation_category => nil)
      c.should_not be_valid
    end

    it "should reject 0 equipment_id" do
      c = FactoryGirl.build(:process_allocx_allocation, :equipment_id => 0)
      c.should_not be_valid
    end
    
    it "should take 0 qty in" do
      c = FactoryGirl.build(:process_allocx_allocation, :qty_in => 0, :qty_out => 0)
      c.should be_valid
    end
    
    it "should take 0 qty out" do
      c = FactoryGirl.build(:process_allocx_allocation, :qty_out => 0)
      c.should be_valid
    end
    
    it "should reject qty out > qty in" do
      c = FactoryGirl.build(:process_allocx_allocation, :qty_in => 1, :qty_out => 2)
      c.should_not be_valid
    end

  end
end
