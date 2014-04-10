class AddImageUidToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :image_uid, :string
  end

  def self.down
    remove_column :products, :image_uid
  end
end
