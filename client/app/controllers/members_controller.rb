MembersController.class_eval do
  
  admin_only :blocked_ip_addresses
  
  def show
    @posts = @member.posts.latest.paginate(:page => params[:page])
  end
  
  def blocked_ip_addresses
    @blocked_ip_addresses = BlockedIpAddress.latest
  end
  
end