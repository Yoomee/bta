class CreateForumsMembers < ActiveRecord::Migration
  def self.up
    create_table :forums_members, :id => false do |t|
      t.integer :forum_id
      t.integer :member_id
    end
    add_column :forums, :is_private, :boolean, :default => false
  end

  def self.down
    remove_column :forums, :is_private
    drop_table :forums_members
  end
end
