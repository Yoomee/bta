class AddingPriceBandFieldsToCart < ActiveRecord::Migration

  def self.up
    add_column :cart_items, :bta_member, :boolean, :default => false
    add_column :cart_items, :overseas, :boolean, :default => false
    add_column :carts, :bta_member, :boolean, :default => false
    add_column :carts, :overseas, :boolean, :default => false
  end

  def self.down
    remove_column :cart_items, :bta_member
    remove_column :cart_items, :overseas
    remove_column :carts, :bta_member
    remove_column :carts, :overseas
  end
  
end
