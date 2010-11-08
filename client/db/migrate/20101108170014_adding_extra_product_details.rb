class AddingExtraProductDetails < ActiveRecord::Migration

  def self.up
    add_column :products, :member_special_offer, :text
  end

  def self.down
    remove_column :products
  end
  
end
