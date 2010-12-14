class AddCarouselPhotoIdToPages < ActiveRecord::Migration
  
  def self.up
    add_column :pages, :carousel_photo_id, :integer
  end

  def self.down
    remove_column :pages, :carousel_photo_id
  end
  
end
