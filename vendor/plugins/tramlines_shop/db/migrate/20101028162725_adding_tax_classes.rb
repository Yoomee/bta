class AddingTaxClasses < ActiveRecord::Migration

  def self.up
    create_table :tax_classes do |t|
      t.string :name
      t.float :rate, :default => 0.0
    end
  end

  def self.down
    drop_table :tax_classes
  end
  
end
