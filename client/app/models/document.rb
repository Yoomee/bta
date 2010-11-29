Document.class_eval do
  named_scope :related_to_page, lambda{|page|{:joins => "INNER JOIN `item_relationships` ON `documents`.id = `item_relationships`.related_item_id AND `item_relationships`.related_item_type = 'Document'", :conditions =>["(`item_relationships`.item_id = ?) AND (`item_relationships`.item_type = 'Page')",page.id]}}  
end