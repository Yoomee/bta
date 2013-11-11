TopicsController.class_eval do

  custom_permission(:show) do |url_options, member|
    if member.nil?
      false
    elsif member.try(:is_admin?)
      true
    else
      topic = Topic.find(url_options[:id])
      topic.forum ? topic.forum.viewable_by?(member) : true
    end
  end
  
  #Action to update a topic of Sticky
  def update
    Post.suspended_delta do
      @topic.update_attributes(params[:topic])
    end
    if @topic.errors.empty?
      flash[:notice] = "Topic Updated Successfully"
      redirect_to @topic.forum
    else
      render :action => 'edit'
    end
  end

end