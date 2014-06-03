class CreateProcessAllocxAllocations < ActiveRecord::Migration
  def change
    create_table :process_allocx_allocations do |t|
      t.integer :equipment_id
      t.integer :operator_id
      t.integer :process_id #parent process
      t.integer :last_updated_by_id
      t.boolean :active, :default => true
      t.integer :qty_in
      t.integer :qty_out
      t.text :description
      t.text :brief_note
      t.datetime :start_date
      t.datetime :end_date
      t.string :allocation_category
      t.integer :status_id

      t.timestamps
    end
    
    add_index :process_allocx_allocations, :equipment_id
    add_index :process_allocx_allocations, :operator_id
    add_index :process_allocx_allocations, :process_id
    add_index :process_allocx_allocations, :allocation_category
    add_index :process_allocx_allocations, :active
    add_index :process_allocx_allocations, :status_id
  end
end
