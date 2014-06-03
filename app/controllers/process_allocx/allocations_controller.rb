require_dependency "process_allocx/application_controller"

module ProcessAllocx
  class AllocationsController < ApplicationController
    before_filter :require_employee
    before_filter :init_resource


    def index
      @title = t('Resource Allocations')
      @allocations = params[:process_allocx_allocations][:model_ar_r]
      @allocations = @allocations.where('process_allocx_allocations.process_id = ?', @process.id) if @process
      @allocations = @allocations.where('TRIM(process_allocx_allocations.allocation_category) = ?', @allocation_category) if @allocation_category
      @allocations = @allocations.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('allocation_index_view_' + @allocation_category, 'process_allocx')
    end

    def new
      @title = t('New Allocation')
      @allocation = ProcessAllocx::Allocation.new()
      session[:allocation_category] = @allocation_category
      @erb_code = find_config_const('allocation_new_view_' + @allocation_category, 'process_allocx')
    end

    def create
      @allocation = ProcessAllocx::Allocation.new(params[:allocation], :as => :role_new)
      @allocation.last_updated_by_id = session[:user_id]
      @allocation_category = session[:allocation_category]
      @allocation.allocation_category = @allocation_category
      if @allocation.save
        session[:allocation_category] = nil
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @process = ProcessAllocx.process_class.find_by_id(params[:allocation][:process_id].to_i) if params[:allocation][:process_id].present?
        @erb_code = find_config_const('allocation_new_view_' + @allocation.allocation_category, 'process_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Allocation')
      @allocation = ProcessAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_edit_view_' + @allocation.allocation_category, 'process_allocx')
    end

    def update
      @allocation = ProcessAllocx::Allocation.find(params[:id])
      @allocation.last_updated_by_id = session[:user_id]
      if @allocation.update_attributes(params[:allocation], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('allocation_edit_view_' + @allocation.allocation_category, 'process_allocx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'edit'
      end

    end

    def show
      @title = t('Allocation Info')
      @allocation = ProcessAllocx::Allocation.find(params[:id])
      @erb_code = find_config_const('allocation_show_view_' + @allocation.allocation_category, 'process_allocx')
    end

    protected
    
    def init_resource
      @process = ProcessAllocx.process_class.find_by_id(ProcessAllocx::Allocation.find_by_id(params[:id]).process_id) if params[:id].present?   
      @process = ProcessAllocx.process_class.find_by_id(params[:process_id].to_i) if params[:process_id].present?
      @allocation_category = ProcessAllocx::Allocation.find_by_id(params[:id]).allocation_category if params[:id].present? 
      @allocation_category = params[:allocation_category].strip if params[:allocation_category].present?
    end

  end
end
