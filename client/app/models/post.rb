Post.class_eval do
  
  after_update :notify_nic
  
  def edited?
    updated_at > created_at
  end
  
  def subject
    deleted? ? "Post deleted" : read_attribute(:subject)
  end
  
  def message
    deleted? ? "Post by #{member} deleted #{updated_at.to_s(:long)}." : read_attribute(:message)
  end
  
  private
  def notify_nic
    if member_nic = Member.nic
      BackgroundRake::bta::notify_nic.call(:post_id => id) unless owned_by?(member_nic)
    end
    true
  end
  
end