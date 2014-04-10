class AddAncestryToDepartments < ActiveRecord::Migration

  def self.up
    add_column :departments, :ancestry, :string
    add_index :departments, :ancestry
  end

  def self.down
    remove_column :departments, :ancestry
    remove_index :departments, :ancestry
  end
end
