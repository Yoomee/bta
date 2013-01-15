Notifier.class_eval do
  
  def enquiry_notification enquiry
    site_name = APP_CONFIG['site_name']
    site_url = APP_CONFIG['site_url']
    recipients enquiry.email_to
    from enquiry.email_from
    bcc "support@yoomee.com"
    if enquiry.form_name == "report"
      cc Member.nic.email
    end
    subject enquiry.email_subject
    content_type  "multipart/alternative"
    locals = {:enquiry => enquiry, :site_name => site_name, :site_url => site_url}
    part :content_type => "text/plain", :body => render_message("enquiry_notification.text.plain", locals)
    part :content_type => "text/html", :body => render_message("enquiry_notification.text.html", locals)
  end
  
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