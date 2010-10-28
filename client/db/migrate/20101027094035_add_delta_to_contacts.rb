class AddDeltaToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :contacts, :delta
  end
end
