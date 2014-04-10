class CreateOrderLinesTable < ActiveRecord::Migration
  
  def self.up
    create_table :order_lines do |t|
      t.belongs_to :order
      t.belongs_to :product
      t.integer :quantity, :default => 1
      t.integer :product_price_in_pence
    end
  end

  def self.down
    drop_table :order_lines
  end
  
end
