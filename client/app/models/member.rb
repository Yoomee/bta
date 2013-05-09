Member.class_eval do
  
  before_save :handle_change_to_banned_from_forum
  
  has_wall
  
  class << self
    
    def nic
      Member.find(9)
    end
    
  end
  
  def block_all_ip_addresses!
    ip_addresses.each do |ip_address|
      BlockedIpAddress.find_or_create_by_ip_address(ip_address)
    end
  end
  
  def ip_addresses
    ip_address.to_s.split(',')
  end
  
  private
  def handle_change_to_banned_from_forum
    return true unless banned_from_forum_changed?
    if banned_from_forum?
      # Just been banned by IP address or admin
      self.whitelisted = false
      block_all_ip_addresses!
    else
      # Just been unbanned by admin
      self.whitelisted = true
    end
  end
  
end