module ProcessAllocx
  class Allocation < ActiveRecord::Base
    attr_accessor :active_noupdate, :last_updated_by_name, :operator_name, :equipment_name, :process_name, :status_name
    attr_accessible :active, :allocation_category, :brief_note, :description, :end_date, :equipment_id, :operator_id, :process_id, :qty_in, 
                    :qty_out, :start_date, :status_id, :process_name,
                    :as => :role_new
    attr_accessible :active, :allocation_category, :brief_note, :description, :end_date, :equipment_id, :operator_id, :process_id, :qty_in, 
                    :qty_out, :start_date, :status_id, 
                    :active_noupdate, :last_updated_by_name, :operator_name, :equipment_name, :process_name, :status_name,
                    :as => :role_update
    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :equipment, :class_name => ProcessAllocx.equipment_class.to_s
    belongs_to :operator, :class_name => 'Authentify::User'
    belongs_to :process, :class_name => ProcessAllocx.process_class.to_s
    belongs_to :status, :class_name => 'Commonx::MiscDefinition'

    validates :allocation_category, :presence => true
    validates :process_id, :equipment_id, :operator_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validates :qty_in, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}, :if => 'qty_in.present?'
    validates :qty_out, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}, :if => 'qty_out.present?'
    validates :qty_out, :numericality => {:less_than_or_equal_to => :qty_in, :message => I18n.t('Wrong Qty Out')}, :if => 'qty_out.present?'
    validate :dynamic_validate
      
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'process_allocx')
      eval(wf) if wf.present?
    end
  end
end
