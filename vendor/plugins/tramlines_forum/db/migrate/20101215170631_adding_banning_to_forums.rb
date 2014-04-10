class AddingBanningToForums < ActiveRecord::Migration

  def self.up
    add_column :members, :banned_from_forum, :boolean, :default => false
  end

  def self.down
    remove_column :members, :banned_from_forum
  end
  
end
