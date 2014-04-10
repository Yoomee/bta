class AddingDepartments < ActiveRecord::Migration

  def self.up
    create_table :departments do |t|
      t.string :name
      t.text :intro
      t.text :description
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :departments
  end
  
end
