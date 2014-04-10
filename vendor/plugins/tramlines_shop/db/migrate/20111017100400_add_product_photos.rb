class AddProductPhotos < ActiveRecord::Migration
  
  def self.up
    create_table :product_photos do |t|
      t.integer :product_id
      t.string :image_uid
      t.timestamps
    end
    add_index :product_photos, :product_id
    Product.all.each do |product|
      unless product.image_uid.blank?
        product.photos.create!(:image_uid => product.image_uid)
      end
    end
    remove_column :products, :image_uid
  end

  def self.down
    add_column :product, :image_uid, :string
    Product.all.each do |product|
      unless product.photos.empty?
        Product.update_attribute(:image_uid, product.photos.first.image_uid)
      end
    end
    drop_table :product_photos
  end
  
end
