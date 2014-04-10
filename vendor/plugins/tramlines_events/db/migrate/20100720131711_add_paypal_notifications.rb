class AddPaypalNotifications < ActiveRecord::Migration

  def self.up
    create_table :paypal_notifications do |t|
      t.integer :booking_id
      t.text :params
      t.string :status
      t.string :transaction_id
    end
  end

  def self.down
    drop_table :paypal_notifications
  end
  
end
