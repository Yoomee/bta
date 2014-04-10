class AddAasmStateToOrders < ActiveRecord::Migration

  def self.up
    add_column :orders, :aasm_state, :string
  end

  def self.down
    remove_column :orders, :aasm_state
  end
  
end
