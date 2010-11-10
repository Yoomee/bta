class AddShowOnFrontPageToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :show_on_front_page, :boolean
  end

  def self.down
    remove_column :sections, :show_on_front_page
  end
end
