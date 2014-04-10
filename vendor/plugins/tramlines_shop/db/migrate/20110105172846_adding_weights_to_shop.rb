class AddingWeightsToShop < ActiveRecord::Migration

  def self.up
    add_column :departments, :weight, :integer, :default => 0
    add_column :products, :weight, :integer, :default => 0
  end

  def self.down
    remove_column :departments, :weight
    remove_column :products, :weight
  end
  
end
