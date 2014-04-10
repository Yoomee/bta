class CreateEventCategories < ActiveRecord::Migration
  
  def self.up
    create_table :event_categories do |t|
      t.string :name
      t.string :color, :default => "#2795E4"
    end
    add_column :events, :category_id, :integer
  end

  def self.down
    remove_column :events, :category_id
    drop_table :event_categories
  end
  
end
