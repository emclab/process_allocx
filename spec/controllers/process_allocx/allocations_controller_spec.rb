require 'spec_helper'

module ProcessAllocx
  describe AllocationsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      @role2 = FactoryGirl.create(:role_definition, :name => 'ceo', :manager_role_id => nil)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ur2 = FactoryGirl.create(:user_role, :role_definition_id => @role2.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      ul2 = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id, :user_id => 2)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @u2 = FactoryGirl.create(:user, :user_levels => [ul2], :user_roles => [ur2], :name => 'name2', :login => 'login2', :email => 'email2@bb.com')
      @alloc_status = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'not available')
      FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'alloc_status', :name => 'vacation')
      
      proc_status = FactoryGirl.create(:commonx_misc_definition, 'for_which' => 'mfg_batch_status')
      @process = FactoryGirl.create(:mfg_batchx_step_qty, :batch_status_id => proc_status.id)
      @equip = FactoryGirl.create(:machine_toolx_machine_tool)
    end
    
    render_views

    describe "GET 'index'" do
      it "returns resource allocations" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProcessAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, allocation_category: 'mfg', :process_id => @process.id, :operator_id => @u.id, :equipment_id => @equip.id)
        alloc2 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id, :equipment_id => @equip.id, allocation_category: 'mfg', :operator_id => @u2.id)
        get 'index', {:use_route => :process_allocx, allocation_category: 'mfg', :process_id => @process.id}
        assigns(:allocations).should =~ [alloc1, alloc2]
      end
      
      it "should only return the allocation for a given detailed_resource_category (e.g project)" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProcessAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id, :operator_id => @u.id, :equipment_id => @equip.id)
        alloc2 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id, :operator_id => @u2.id, :equipment_id => @equip.id)
        get 'index', {:use_route => :process_allocx, allocation_category: 'mfg', :process_id => @process.id}
        assigns(:allocations).should =~ []
      end
      
      it "should only return the allocation for a given process_id & allocation category" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "ProcessAllocx::Allocation.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id, :operator_id => @u.id, :equipment_id => @equip.id)
        alloc2 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :allocation_category => 'new new', :process_id => @process.id, :operator_id => @u2.id, :equipment_id => @equip.id)
        get 'index', {:use_route => :process_allocx, allocation_category: alloc1.allocation_category, :process_id => @process.id}
        assigns(:allocations).should =~ [alloc1]
      end
      
    end
  
    describe "GET 'new'" do
      it "bring up new page with allocation" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1, :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , {:use_route => :process_allocx, allocation_category: 'mfg', :process_id => @process.id }
        response.should be_success
        #assigns[:resourse_category].should eq('production')
      end

      it "bring up new page with allocation with man_power" do
        FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        #manpower1 = FactoryGirl.attributes_for(:resource_allocx_man_power)
        alloc = FactoryGirl.attributes_for(:process_allocx_allocation, :status_id => @alloc_status.id)
        get 'new' , {:use_route => :process_allocx, :allocation => alloc, allocation_category: 'mfg', :process_id => @process.id}
        response.should be_success
        #assigns[:resourse_category].should eq('production')
      end


    end
  
    describe "GET 'create'" do
      it "should create new allocation because of proper right access" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:allocation_category] = 'man_power'
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.attributes_for(:process_allocx_allocation, :status_id => @alloc_status.id, allocation_category: 'mfg')
        get 'create', {:use_route => :process_allocx, :allocation => alloc}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should create new allocation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:allocation_category] = 'man_power'
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc1 = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id)
        alloc2 = FactoryGirl.attributes_for(:process_allocx_allocation, :status_id => @alloc_status.id)
        get 'create', {:use_route => :process_allocx, :allocation => alloc2}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end

      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:allocation_category] = 'man_power'
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.attributes_for(:process_allocx_allocation, :operator_id => 0, :status_id => @alloc_status.id)
        get 'create', {:use_route => :process_allocx, :allocation => alloc, :process_id => @process.id}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id, :last_updated_by_id => @u.id)
        get 'edit', {:use_route => :process_allocx, :id => alloc.id, :process_id => @process.id}
        response.should be_success
      end

    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id)
        get 'update', {:use_route => :process_allocx, :id => alloc.id, :allocation => {:equipment_id => 1}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        alloc = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id)
        get 'update', {:use_route => :process_allocx, :id => alloc.id, :allocation => {:operator_id => 0}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        FactoryGirl.create(:user_access, :action => 'show', :resource =>'process_allocx_allocations', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        engine = FactoryGirl.create(:mfg_batchx_step_qty)
        alloc = FactoryGirl.create(:process_allocx_allocation, :status_id => @alloc_status.id, :process_id => @process.id)
        get 'show', {:use_route => :process_allocx, :id => alloc.id}
        response.should be_success
      end
    end

  end
end
