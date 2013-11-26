class AddNewGiftAidFieldsToCart < ActiveRecord::Migration
  def self.up
    add_column :carts, :donation_gift_aid_past, :boolean, :default => false
    add_column :carts, :donation_gift_aid_today, :boolean, :default => false
    add_column :carts, :donation_gift_aid_future, :boolean, :default => false
  end

  def self.down
    remove_column :carts, :donation_gift_aid_past
    remove_column :carts, :donation_gift_aid_today
    remove_column :carts, :donation_gift_aid_future
  end
end
