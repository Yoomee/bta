class AddingPaypalDetails < ActiveRecord::Migration

  def self.up
    add_column :events, :paypal_business, :string
    add_column :events, :paypal_payment_amount, :float, :default => 0
    add_column :events, :use_paypal, :boolean, :default => false
  end

  def self.down
    remove_column :events, :paypal_business
    remove_column :events, :paypal_payment_amount
    remove_column :events, :use_paypal
  end
  
end
