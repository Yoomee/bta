class CreateContactCategories < ActiveRecord::Migration
  def self.up
    create_table :contact_categories do |t|
      t.string :name
      t.string :color, :default => "#000000"
      t.timestamps
    end
  end

  def self.down
    drop_table :contact_categories
  end
end
