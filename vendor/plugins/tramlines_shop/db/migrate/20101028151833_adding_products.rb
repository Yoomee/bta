class AddingProducts < ActiveRecord::Migration

  def self.up
    create_table :products do |t|
      t.string :name
      t.integer :department_id
      t.text :overview
      t.text :description
      t.integer :tax_class_id
      t.integer :price_in_pence
      t.string :price_stored_as, :default => 'NET'
      t.integer :weight_in_grams
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :products
  end

end
