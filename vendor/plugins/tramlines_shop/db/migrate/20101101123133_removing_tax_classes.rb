require "vendor/plugins/tramlines_shop/db/migrate/20101028162725_adding_tax_classes"
class RemovingTaxClasses < ActiveRecord::Migration

  def self.up
    AddingTaxClasses.down
    remove_column :products, :tax_class_id
    remove_column :products, :weight_in_grams
    remove_column :products, :price_stored_as
  end

  def self.down
    AddingTaxClasses.up
    add_column :products, :tax_class_id, :integer
    add_column :products, :weight_in_grams, :integer
    add_column :products, :price_stored_as, :string, :default => 'NET'
  end
  
end
