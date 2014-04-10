class ChangingOnsToAts < ActiveRecord::Migration

  def self.up
    rename_column :forums, :created_on, :created_at
    rename_column :forums, :updated_on, :updated_at
    rename_column :posts, :created_on, :created_at
    rename_column :posts, :updated_on, :updated_at
    rename_column :topics, :created_on, :created_at
    rename_column :topics, :updated_on, :updated_at
  end

  def self.down
    rename_column :forums, :created_at, :created_on
    rename_column :forums, :updated_at, :updated_on
    rename_column :posts, :created_at, :created_on
    rename_column :posts, :updated_at, :updated_on
    rename_column :topics, :created_at, :created_on
    rename_column :topics, :updated_at, :updated_on
  end
  
end
