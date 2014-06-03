require "process_allocx/engine"

module ProcessAllocx
  mattr_accessor :equipment_class, :process_class
  
  def self.equipment_class
    @@equipment_class.constantize
  end
  
  def self.process_class
    @@process_class.constantize
  end
end
