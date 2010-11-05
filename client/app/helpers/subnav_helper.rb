module SubnavHelper
  def render_subnav(section, page_or_section, level=1)
    html = "<ul class='lst level#{level}'>"
    section.all_children.each do |child|
      html << li_with_active(current_page?(:controller => "#{child.is_a?(Page) ? 'pages' : 'sections'}", :action => "show", :id => child), :class => "#{'has_children' if child.is_a?(Section) && !child.all_children.empty?}#{' active_parent' if child.is_a?(Section) && child.has_descendant?(page_or_section)}") do
        link_to(child.title, child)
      end
      if child.is_a?(Section) && !child.all_children.blank? && (child == page_or_section || child.has_descendant?(page_or_section))
        html << render_subnav(child, page_or_section, level + 1)
      end
    end
    html << "</ul>"  
  end
  
  def render_shop_subnav(department, product_or_department, level=1)
    html = "<ul class='lst level#{level}'>"
    department.all_children.each do |child|
      html << li_with_active(current_page?(:controller => "#{child.is_a?(Product) ? 'products' : 'departments'}", :action => "show", :id => child), :class => "#{'has_children' if child.is_a?(Department) && !child.all_children.empty?}#{' active_parent' if child.is_a?(Department) && child.has_descendant?(product_or_department)}") do
        link_to(child.name, child)
      end
      if child.is_a?(Department) && !child.all_children.blank? && (child == product_or_department || child.has_descendant?(product_or_department))
        html << render_shop_subnav(child, product_or_department, level + 1)
      end
    end
    html << "</ul>"  end
end