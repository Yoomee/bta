class AddingDonationsToCarts < ActiveRecord::Migration

  def self.up
    add_column :carts, :donation_amount_in_pence, :integer, :default => 0
    add_column :carts, :donation_gift_aid, :boolean, :default => false
  end

  def self.down
    remove_column :carts, :donation_amount_in_pence
    remove_column :carts, :donation_gift_aid
  end
  
end
