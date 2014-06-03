require 'spec_helper'

describe "LinkeTests" do
  describe "GET /process_allocx_linke_tests" do
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      FactoryGirl.create(:user_access, :action => 'index', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => 'ProcessAllocx::Allocation.scoped')
      FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => nil)
      FactoryGirl.create(:user_access, :action => 'update', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'show', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      @alloc_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'alloc_status', :name => 'available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'not available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'vacation')

      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_resource_man_power', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_positions_man_power', :argument_value => "team lead,workman,electricien")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_resource_heavy_machine', :argument_value => "Authentify::UsersHelper.return_users('create', params[:controller])")
      FactoryGirl.create(:engine_config, :engine_name => 'resource_allocx', :engine_version => nil, :argument_name => 'allocation_positions_heavy_machine', :argument_value => "machine1,machine2, machine3")
      
      proc_status = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'mfg_batch_status')
      @process = FactoryGirl.create(:mfg_batchx_step_qty, :batch_status_id => proc_status.id)
      @equip = FactoryGirl.create(:machine_toolx_machine_tool)

      visit '/'
      #login
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      alloc = FactoryGirl.create(:process_allocx_allocation, :last_updated_by_id => @u.id, :status_id => @alloc_status.id, allocation_category: 'mfg', :process_id => @process.id, :operator_id => @u.id, :equipment_id => @equip.id)
      visit allocations_path(allocation_category: 'mfg', :process_id => @process.id)
      click_link alloc.id.to_s
      save_and_open_page
      page.should have_content('Allocation Info')
      #edit
      visit allocations_path(allocation_category: 'mfg', :process_id => @process.id)
      click_link 'Edit'
      #select('not available', from: 'allocation_status_id')
      fill_in 'allocation_description', :with => 'new new'
      click_button "Save"
      save_and_open_page
      #bad data
      visit allocations_path(allocation_category: 'mfg', :process_id => @process.id)
      click_link 'Edit'
      select('', from: 'allocation_equipment_id')
      click_button 'Save'
      save_and_open_page
    end
    
    it "should display new allocation page and save new" do
      visit allocations_path(allocation_category: 'mfg', :process_id => @process.id)
      save_and_open_page
      click_link 'New Allocation'
      save_and_open_page
      page.body.should have_content('New Allocation')
      fill_in 'allocation_description', with: 'engineer position'
      #select('vacation', from: 'allocation_status_id')
      select(@u.name, from: 'allocation_operator_id')
      select(@equip.name, from: 'allocation_equipment_id')
      click_button 'Save'
      
      visit allocations_path(allocation_category: 'mfg', :process_id => @process.id)
      save_and_open_page
      #bad data
      click_link 'New Allocation'
      fill_in 'allocation_description', with: 'a new description'
      #select('vacation', from: 'allocation_status_id')
      select(@u.name, from: 'allocation_operator_id')
      select('', from: 'allocation_equipment_id')      
      click_button 'Save'
      #save_and_open_page #do you see can't blank after position?
      visit allocations_path(:allocation_category => 'mfg', :process_id => @process.id)
      page.should_not have_content('a new description')
      #save_and_open_page
    end
  end
end
