class CreateEvents < ActiveRecord::Migration
  
  def self.up
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day
      t.string :attachable_type
      t.integer :attachable_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
  
end
