# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :process_allocx_allocation, :class => 'ProcessAllocx::Allocation' do
    equipment_id 1
    operator_id 1
    process_id 1
    #last_updated_by_id 1
    active true
    qty_in 1
    qty_out 1
    description "MyText"
    brief_note "MyText"
    start_date "2014-06-02 11:52:35"
    end_date "2014-06-02 11:52:35"
    allocation_category "MyString"
    status_id 1
  end
end
