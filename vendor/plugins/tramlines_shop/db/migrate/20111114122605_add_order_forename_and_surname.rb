class AddOrderForenameAndSurname < ActiveRecord::Migration
  
  def self.up
    remove_column :orders, :recipient_name
    add_column :orders, :forename, :string
    add_column :orders, :surname, :string
  end

  def self.down
    remove_column :orders, :forename
    remove_column :orders, :surname
    add_column :orders, :recipient_name, :string
  end
  
end
