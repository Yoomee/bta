class AddingCartItems < ActiveRecord::Migration

  def self.up
    create_table :cart_items do |t|
      t.integer :cart_id
      t.integer :product_id
      t.integer :quantity, :default => 1
    end
  end

  def self.down
    drop_table :cart_items
  end
  
end
