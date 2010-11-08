class AddShowInCarouselToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_in_carousel, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :show_in_carousel
  end
end
