module CampaignsHelper
  
  def root_slug_is?(slug) 
    return false if current_section.nil? || current_section.slug == slug
    current_section.absolute_root.slug == slug
  end
  
  def in_campaigns?
    root_slug_is?('campaigns')
  end
  
  def campaign_bg_color
    return nil if !in_campaigns?
    "background-color:#{current_section.bg_color}"
  end
  
  def campaign_header_image_url
    return nil if !in_campaigns?
    current_section.header_image.nil? ? '' : current_section.header_image.url
  end
  
  private
  def current_section
    @section.nil? ? (@page.nil? ? nil : @page.section) : @section
  end
  
end