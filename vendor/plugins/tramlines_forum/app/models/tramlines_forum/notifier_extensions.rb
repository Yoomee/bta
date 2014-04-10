module TramlinesForum::NotifierExtensions

  def post_notification member, post
    recipients member.email
    from APP_CONFIG[:site_email]
    subject "Reply to thread #{post.topic.subject}"
    @post, @member = post, member
    content_type  "multipart/alternative"
    part :content_type => "text/plain", :body => render_message("post_notification.text.plain", {})
    part :content_type => "text/html", :body => render_message("post_notification.text.html", {})
  end

end
