class AddIncludeDonateButtonToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :include_donate_button, :boolean
  end

  def self.down
    remove_column :pages, :image_centre
  end
end
