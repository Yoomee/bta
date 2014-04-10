class CreateRatings < ActiveRecord::Migration
  
  def self.up
    create_table :ratings do |t|
      t.belongs_to :member
      t.belongs_to :rateable, :polymorphic => true
      t.integer :score, :default => 1
      t.timestamps 
    end
    
    add_index :ratings, :member_id
    add_index :ratings, [:rateable_id, :rateable_type]
  end

  def self.down
    drop_table :ratings
  end
  
end
