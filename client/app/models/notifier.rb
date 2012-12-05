Notifier.class_eval do
  
  def post_notification member, post
    recipients member.email
    from APP_CONFIG[:site_email]
    if post.deleted?
      subject "Post deleted in thread #{post.topic.subject}"
    elsif post.edited?
      subject "Post edited in thread #{post.topic.subject}"
    else
      subject "Reply to thread #{post.topic.subject}"
    end
    @post, @member = post, member
    content_type  "multipart/alternative"
    part :content_type => "text/plain", :body => render_message("post_notification.text.plain", {})
    part :content_type => "text/html", :body => render_message("post_notification.text.html", {})
  end
  
end