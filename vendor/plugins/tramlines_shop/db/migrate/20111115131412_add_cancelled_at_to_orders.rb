class AddCancelledAtToOrders < ActiveRecord::Migration
  
  def self.up
    add_column :orders, :cancelled_at, :datetime, :default => nil
  end

  def self.down
    remove_column :orders, :cancelled_at
  end
  
end
