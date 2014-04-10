class AddBookings < ActiveRecord::Migration

  def self.up
    create_table :bookings do |t|
      t.date :date_of_birth
      t.string :email
      t.integer :event_id
      t.string :first_name
      t.string :gender
      t.string :phone_number
      t.string :surname
      t.string :where_did_you_hear_about_the_event
      t.string :payment_status
    end
  end

  def self.down
    drop_table :bookings
  end
  
end
