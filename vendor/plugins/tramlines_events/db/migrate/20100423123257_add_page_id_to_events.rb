class AddPageIdToEvents < ActiveRecord::Migration
  
  def self.up
    add_column :events, :page_id, :integer
    add_index :events, :page_id
  end

  def self.down
    remove_column :events, :page_id
  end
  
end
