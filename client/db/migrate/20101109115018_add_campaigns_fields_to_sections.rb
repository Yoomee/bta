class AddCampaignsFieldsToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :bg_color, :string, :default => "#F0F3F7"
    add_column :sections, :header_image_uid, :string
    add_column :sections, :front_page_image_uid, :string
  end

  def self.down
    remove_column :sections, :front_page_image_uid
    remove_column :sections, :header_image_uid
    remove_column :sections, :bg_color
  end
end
