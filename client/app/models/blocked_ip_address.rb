class BlockedIpAddress < ActiveRecord::Base
  
  validates_presence_of :ip_address
  
  def banned_members
    Member.find(:all, :conditions => "banned_from_forum = 1 AND ip_address REGEXP '(^|.*,)#{ip_address}($|,.*)'", :group => :id, :order => "members.surname,members.forename")
  end
  
  def other_members
    Member.find(:all, :conditions => "banned_from_forum = 0 AND ip_address REGEXP '(^|.*,)#{ip_address}($|,.*)'", :group => :id, :order => "members.surname,members.forename")
  end
  
  def to_s
    ip_address
  end
  
end