# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :machine_toolx_machine_tool, :class => 'MachineToolx::MachineTool' do
    name "MyString"
    #short_name "MyString"
    purchase_date "2013-08-28"
    mfg_date "2013-08-28"
    model_num "MyString"
    serial_num "MyString"
    mfr "MyString"
    status_id 1
    #spec "MyText"
    tech_spec "MyText"
    decommissioned false
    last_updated_by_id 1
    main_power_w 1
    voltage "MyString"
    category_id 1
    operator_id 1
    accessory "MyText"
    lubricant "MyText"
    coolant "MyText"
    work_piece "MyText"
    weight_kg 1
    dimension "MyString"
    rpm "MyString"
    tool "MyText"
    precision "MyText"
    note 'decommisssioned'
    op_cost_hourly 20.10
  end
end
