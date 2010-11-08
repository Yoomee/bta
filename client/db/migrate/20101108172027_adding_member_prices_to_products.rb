class AddingMemberPricesToProducts < ActiveRecord::Migration

  def self.up
    add_column :products, :member_price_in_pence, :integer, :null => true
  end

  def self.down
    remove_column :products, :member_price_in_pence
  end
  
end
