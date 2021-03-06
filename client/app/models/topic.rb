Topic.class_eval do

  after_create :notify_nic
  
  # always notify nic when anyone posts in the forum
  def notify_others_with_nic post
    member_nic = Member.nic
    if member_nic && !post.owned_by?(member_nic) && !posts.exists?(:member_id => member_nic.id, :email => true)
      BackgroundRake::bta::notify_nic.call(:post_id => post.id)
      #Notifier.deliver_post_notification(member_nic, post)
    end
    notify_others_without_nic(post)
  end
  alias_method_chain :notify_others, :nic
  
  private
  def notify_nic
    if (member_nic = Member.nic) && (post = posts.first)
      BackgroundRake::bta::notify_nic.call(:post_id => post.id) unless post.owned_by?(member_nic)
      #Notifier.deliver_post_notification(member_nic, post) unless post.owned_by?(member_nic)
    end
    true
  end
  
end