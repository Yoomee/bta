class AddDeltasToForumModels < ActiveRecord::Migration
  
  def self.up
    add_column :posts, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :posts, :delta
  end
  
end
