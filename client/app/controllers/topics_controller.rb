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
  
end