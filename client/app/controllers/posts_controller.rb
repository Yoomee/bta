PostsController.class_eval do
  
  member_only :report
  
  def destroy
    @topic = @post.topic
    if @topic.posts.count > 1
      if @post.update_attribute(:deleted, true)
        flash[:notice] = "Post Deleted"
        redirect_to forum_topic_path(:forum_id => @topic.forum, :id => @topic)
      end
    else
      redirect_to @topic, :method => :delete
    end
  end
  
  def report
    get_post
    @enquiry = Enquiry.new(:form_name => "report", :member => @logged_in_member, :post => @post)
    render :template => "enquiries/new"
  end
  
  
end