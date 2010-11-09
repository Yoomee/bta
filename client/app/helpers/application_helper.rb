ApplicationHelper.module_eval do
  
  def root_slug_is?(slug) 
    return false if current_section.nil? || current_section.slug == slug
    current_section.absolute_root.slug == slug
  end
  
  def campaign_bg_color
    return nil if !root_slug_is?('campaigns')
    "background-color:#{'#000'}" #current_section.bg_color}
  end
  
  private
  def current_section
    @section.nil? ? (@page.nil? ? nil : @page.section) : @section
  end
  
end
