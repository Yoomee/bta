PostsController.class_eval do
  
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
  
  
end