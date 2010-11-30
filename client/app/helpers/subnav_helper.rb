module SubnavHelper

  def render_subnav(section, page_or_section, level=1, published_only=nil)
    if RAILS_ENV != 'test'
      published_only ||= @logged_in_member.nil? || !@logged_in_member.is_admin?
      html = "<ul class='lst level#{level}'>"
      section.all_children(:published_only => published_only).each do |child|
        html << li_with_active(current_page?(:controller => "#{child.is_a?(Page) ? 'pages' : 'sections'}", :action => "show", :id => child), :class => "#{'has_children' if child.is_a?(Section) && !child.all_children(:published_only => published_only).empty?}#{' active_parent' if child.is_a?(Section) && child.has_descendant?(page_or_section)}") do
          link_to(child.title, child)
        end
        if child.is_a?(Section) && !child.all_children(:published_only => published_only).blank? && (child == page_or_section || child.has_descendant?(page_or_section))
          html << render_subnav(child, page_or_section, level + 1, published_only)
        end
      end
      html << "</ul>"
    end
  end

  def render_shop_subnav(department, product_or_department, level=1)
    if RAILS_ENV != 'test'
      html = "<ul class='lst level#{level}'>"
      children = (level == 1 && department.is_root?) ? Department.roots.active : department.all_active_children
      children.each do |child|
        html << li_with_active(current_page?(:controller => "#{child.class.to_s.downcase.pluralize}", :action => "show", :id => child), :class => "#{'has_children' if child.is_a?(Department) && !child.all_children.empty?}#{' active_parent' if child.is_a?(Department) && child.has_descendant?(product_or_department)}") do
          link_to(child.name, child)
        end
        if child.is_a?(Department) && !child.all_active_children.blank? && (child == product_or_department || child.has_descendant?(product_or_department))
          html << render_shop_subnav(child, product_or_department, level + 1)
        end
      end
      html << "</ul>" 
    end
  end

end