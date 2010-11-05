BlogsHelper.module_eval do
  
  def render_blog_sidebar(blog = nil)
    blog ||= get_blog
    return "" if blog.nil?    
    html = "<ul class='lst level1'>"
    html << li_with_active(@blog == blog, link_to(blog, blog))
    html << "<ul class='lst level2'>"
    blog.blog_posts.latest.limit(6).each do |blog_post|
      html << li_with_active(current_page?(:controller => "blog_posts", :action => "show", :id => blog_post), link_to(blog_post, blog_post))
    end
    html << "</ul></ul>"
  end
  
  def get_blog
    return @blog if !@blog.nil?
    @blog_post.nil? ? nil : @blog_post.blog
  end
  
end