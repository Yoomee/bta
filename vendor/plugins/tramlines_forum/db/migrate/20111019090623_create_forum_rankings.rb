class CreateForumRankings < ActiveRecord::Migration
  def self.up
    create_table :forum_rankings do |t|
      t.string :name
      t.integer :num_posts_needed
    end
    add_column :members, :forum_ranking_id, :integer
    add_index :members, :forum_ranking_id
  end

  def self.down
    remove_column :members, :forum_ranking_id
    drop_table :forum_rankings
  end
end
