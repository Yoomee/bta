class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.belongs_to :attachable, :polymorphic => true
      t.string :reference
      t.integer :payment_pence
      t.boolean :uk_taxpayer
      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
