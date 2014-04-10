module TopicsHelper

  def file_uploads? forum
    forum.allow_uploads == 1
  end
  
  def get_message_icon post
    icon = post.get_icon
    if icon
     image_tag("forum/message_icons/#{icon}")
    end
  end

  def link_to_last_post topic
    "Last post: #{link_to_poster(topic.get_last_poster)} at #{topic.get_last_post.created_at.to_s(:short)}"
  end
  
end
