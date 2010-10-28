class CreateContacts < ActiveRecord::Migration
  
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :website
      t.string :phone_number
      t.string :image_uid
      t.integer :category_id
      t.timestamps      
    end
  end

  def self.down
    drop_table :contacts
  end
  
end
