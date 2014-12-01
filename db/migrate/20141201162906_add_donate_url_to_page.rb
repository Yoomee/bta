class AddDonateUrlToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :donate_url, :string
  end

  def self.down
    remove_column :pages, :donate_url
  end
end
