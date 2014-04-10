class AddExtraOrderFields < ActiveRecord::Migration
  
  def self.up
    add_column :orders, :email, :string
    add_column :orders, :recipient_name, :string
    add_column :orders, :transaction_reference, :string
    add_column :orders, :hashed_reference, :string
  end

  def self.down
    remove_column :orders, :email
    remove_column :orders, :recipient_name
    remove_column :orders, :transaction_reference
    remove_column :orders, :hashed_reference
  end
  
end
