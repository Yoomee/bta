MembersController.class_eval do
  
  admin_only :blocked_ip_addresses
  
  def create_with_auth
    @member = Member.new(params[:member])
    @member.generate_random_password(true) if logged_in_member_is_admin?
    if @member.save
      login_member!(@member, :redirect => false)
      if Module.value_to_boolean(params[:in_popup])
        render(:text => "<script type='text/javascript'>window.close()</script>")
      elsif logged_in_member_is_admin?
        flash[:notice] = "The account has been created."
        redirect_to_waypoint
      else
        flash[:notice] = "Your account has been created. Welcome to #{APP_CONFIG['site_name']}."
        redirect_to @member
      end
    elsif @member.twitter_connected? || @member.facebook_connected? || @member.linked_in_connected?
      session[:auth_data] = nil
      case @member.auth_service
      when 'Facebook'
        session[:auth_data] = {:auth_service => 'Facebook', :auth_id => @member.fb_user_id}
      when 'Twitter'
        session[:auth_data] = {:auth_service => 'Twitter', :auth_id => @member.twitter_id, :auth_username => @member.twitter_username, :auth_token => @member.twitter_token, :auth_secret => @member.twitter_secret}
      when 'LinkedIn'
        session[:auth_data] = {:auth_service => 'LinkedIn', :auth_id => @member.linked_in_user_id, :auth_token => @member.linked_in_token, :auth_secret => @member.linked_in_secret}
      end
      @existing_member = Member.find_by_email(@member.email)
      render :template => 'sessions/register_email'
    else
      render :action => logged_in_member_is_admin?  ? 'new_by_admin' : 'new'
    end
  end
  
  def show
    @posts = @member.posts.latest.paginate(:page => params[:page])
  end
  
  def blocked_ip_addresses
    @blocked_ip_addresses = BlockedIpAddress.latest
  end
  
end