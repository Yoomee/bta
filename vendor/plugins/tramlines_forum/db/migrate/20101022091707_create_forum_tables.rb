class CreateForumTables < ActiveRecord::Migration
  def self.up
    create_table "forums", :force => true do |t|
      t.string   "title",            :default => "", :null => false
      t.text     "description",                      :null => false
      t.integer  "allow_uploads",    :default => 0,  :null => false
      t.datetime "created_on",                       :null => false
      t.datetime "updated_on",                       :null => false
    end

    create_table "topics", :force => true do |t|
      t.integer  "forum_id"
      t.integer  "views",      :default => 0
      t.integer  "replies",    :default => 0
      t.integer  "sticky",     :default => 0
      t.integer  "member_id"
      t.datetime "created_on",                :null => false
      t.datetime "updated_on",                :null => false
    end

    add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
    add_index "topics", ["member_id"], :name => "index_topics_on_member_id"


    create_table "posts", :force => true do |t|
      t.integer  "topic_id"
      t.integer  "member_id"
      t.string   "subject",      :default => "", :null => false
      t.text     "message",                      :null => false
      t.string   "message_icon"
      t.integer  "email",        :default => 0
      t.string   "file"
      t.datetime "created_on"
      t.datetime "updated_on"
    end

    add_index "posts", ["member_id"], :name => "index_posts_on_member_id"
    add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
    
    create_table "post_viewings", :id => false, :force => true do |t|
      t.integer "member_id", :null => false
      t.integer "post_id",   :null => false
    end

    add_index "post_viewings", ["member_id"], :name => "index_post_viewings_on_member_id"
    
  end

  def self.down
    drop_table "forums"
    drop_table "topics"
    drop_table "posts"
    drop_table "post_viewings"
  end                             
end
