module ForumsHelper  

  def allowed_forums forumcategory, member
	 forums = Array.new
     forumcategory.forums.each do |forum|
         options = {:controller => 'forum', :action => 'show', :id => forum.id, :member => member }
         if Permission.allowed_to? options
            forums << forum
         end
     end
    forums
  end
  
  def forum_ranking_select_collection
    [["Based on number of posts", nil]] + ForumRanking.num_posts_needed_null.collect {|fr| [fr.name, fr.id]}
  end
  
  def get_image item
    image_tag("forum/#{get_post_image(item)}")
  end
  
  def get_last_post_details topic
    post = topic.get_last_post
    out = (post.get_icon ? link_to(image_tag("forum/message_icons/#{post.get_icon}"), post) : "")
    out << link_to_poster(post.member)
    out << " at #{post.created_at.to_s(:short)}"
  end

  def get_last_post_info forum
    return "n/a" if forum.posts.empty?
    post = forum.get_last_post
    out = (post.get_icon ? link_to(image_tag("forum/message_icons/#{post.get_icon}"), post) : "")
    out << link_to_poster(post.member)
    out << " at #{post.created_at.to_s(:short)}"
  end

  def link_to_poster poster
    return "Anonymous" if poster.nil?
    link_to_self(poster)
  end

  def get_last_voter_name poll
    voter = poll.get_last_voter
    if voter
      link_if_allowed(voter.full_name, voter)
    end
  end
  
  def get_message_icon topic_or_post
    icon = topic_or_post.is_a?(Topic) ? topic_or_post.get_last_post_icon : topic_or_post.get_icon
    if icon
      image_tag("forum/message_icons/#{icon}")
    end
  end
 
  def get_poll_image poll
    Poll.new_poll_image
  end
  
  # def get_post_image topic
  #   if @m
  #     topic.new_posts? @m
  #   else
  #     if session[:visit_time]
  #       topic.new_posts_since session[:visit_time]
  #     end
  #   end
  # end
  # 
  def last_vote_or_post_message item
    if item.kind_of?(Topic)
      item.posts.last.message
    else
      link_to_last_voter item
    end
  end

  def link_to_delete_item item, options = {}
    options[:prefix] ||= ''
    if item.is_a?(Topic)
      link_if_allowed 'Delete', {:controller => 'topic', :action => 'delete', :id => item.id}, :confirm => 'Are you sure you wish to delete this topic?', :prefix => options[:prefix]
    elsif item.is_a?(Poll)
      link_if_allowed 'Delete', {:controller => 'poll', :action => 'delete', :id => item.id}, :confirm => 'Are you sure you wish to delete this poll?', :prefix => options[:prefix]
    end
  end

  def link_to_edit_item item
    if item.is_a?(Topic)
      link_if_allowed 'Edit', :controller => 'topic', :action => 'edit', :id => item.id
    elsif item.is_a?(Poll)
      link_if_allowed 'Edit', :controller => 'poll', :action => 'edit', :id => item.id
    end
  end
    
  def link_to_forum_item item, options = {}
    if options[:force_allowed]
      if item.is_a?(Topic)
        link_to item.get_subject, {:controller => 'topic', :action => 'show', :id => item.id}, :title => truncate(item.get_last_message, 50)
      elsif item.is_a?(Poll)
        link_to item.get_subject, {:controller => 'poll', :action => 'show', :id => item.id}
      end  
    else
      options[:prefix] ||= ''
      if item.is_a?(Topic)
        link_if_allowed item.get_subject, {:controller => 'topic', :action => 'show', :id => item.id, :prefix => options[:prefix]}, :title => truncate(item.get_last_message, 50)
      elsif item.is_a?(Poll)
        link_if_allowed item.get_subject, {:controller => 'poll', :action => 'show', :id => item.id, :prefix => options[:prefix]}
      end
    end
  end

  def link_to_last_voter item
    if item.get_votes > 0
      "Last vote: #{get_last_voter_name item} at #{item.created_at.to_s(:short)}"
    else
      "n/a"
    end
  end

  def viewing_forum?
    controller_name.in? %w{forums posts topics}
  end

end
 
