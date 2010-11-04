module PagesHelper
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
end