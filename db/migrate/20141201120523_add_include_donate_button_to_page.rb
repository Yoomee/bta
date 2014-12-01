class AddIncludeDonateButtonToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :include_donate_button, :boolean
  end

  def self.down
    remove_column :pages, :include_donate_button
  end
end
