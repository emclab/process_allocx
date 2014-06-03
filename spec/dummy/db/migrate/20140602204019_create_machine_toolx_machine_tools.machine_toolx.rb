# This migration comes from machine_toolx (originally 20130828174337)
class CreateMachineToolxMachineTools < ActiveRecord::Migration
  def change
    create_table :machine_toolx_machine_tools do |t|
      t.string :name
      #t.string :short_name
      t.date :purchase_date
      t.date :mfg_date
      t.string :model_num
      t.string :serial_num
      t.string :mfr
      t.integer :status_id
      t.text :tech_spec
      t.boolean :decommissioned, :default => false
      t.integer :last_updated_by_id
      t.integer :main_power_w
      t.string :voltage
      t.integer :category_id
      t.integer :operator_id
      t.text :accessory
      t.text :lubricant
      t.text :coolant
      t.text :work_piece
      t.integer :weight_kg
      t.string :dimension
      t.string :rpm
      t.text :tool
      t.text :precision
      t.text :note
      t.decimal :op_cost_hourly, :precision => 8, :scale => 2

      t.timestamps
    end
    
    add_index :machine_toolx_machine_tools, :category_id
    add_index :machine_toolx_machine_tools, :status_id
    add_index :machine_toolx_machine_tools, :name
    add_index :machine_toolx_machine_tools, :model_num
  end
end
