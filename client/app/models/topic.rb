Topic.class_eval do
  
  # always notifiy nic when anyone posts in the forum
  def notify_others_with_nic post
    member_nic = Member.find_by_email("ian@yoomee.com")
    if !post.owned_by?(member_nic) && !posts.exists?(:member_id => member_nic.id, :email => true)
      Notifier.deliver_post_notification(member_nic, post)
    end
    notify_others_without_nic(post)
  end
  alias_method_chain :notify_others, :nic
  
end