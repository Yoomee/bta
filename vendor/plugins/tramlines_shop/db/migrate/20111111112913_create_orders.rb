class CreateOrders < ActiveRecord::Migration
  
  def self.up
    create_table :orders do |t|
    end
  end

  def self.down
    drop_table :orders
  end
  
end
