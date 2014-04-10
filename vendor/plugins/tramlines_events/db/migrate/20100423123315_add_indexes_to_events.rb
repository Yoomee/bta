class AddIndexesToEvents < ActiveRecord::Migration
  
  def self.up
    add_index :events, :attachable_id
  end

  def self.down
    remove_index :events, :attachable_id
  end
end
