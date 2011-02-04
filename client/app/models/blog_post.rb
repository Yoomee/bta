BlogPost.class_eval do
  
  has_related_items
  has_snippets
  
  belongs_to :author_photo, :class_name => "Photo", :autosave => true
  
end