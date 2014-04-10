class AddDispatchedAtToOrders < ActiveRecord::Migration
  
  def self.up
    add_column :orders, :dispatched_at, :datetime, :default => nil
  end

  def self.down
    remove_column :orders, :dispatched_at
  end
  
end
