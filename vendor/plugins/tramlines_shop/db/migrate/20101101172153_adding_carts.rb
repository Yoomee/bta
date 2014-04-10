class AddingCarts < ActiveRecord::Migration

  def self.up
    create_table :carts do |t|
      t.integer :member_id
    end
  end

  def self.down
    drop_table :carts
  end
  
end
