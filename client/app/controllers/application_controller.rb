ApplicationController.class_eval do
  include Facebooker2::Rails::Controller

  ExceptionNotifier.email_prefix = 'BTA: '
  ExceptionNotifier.exception_recipients = 'developers@yoomee.com'

  skip_before_filter :force_password_change
  
  #before_filter :log_out
  
  def login_member!(member, options = {})
    options.reverse_merge!(:redirect => true, :super => false, :remember_me => false)
    @logged_in_member = member
    store_remember_me_cookies(@logged_in_member) if options[:remember_me]
    session[:logged_in_member_id] = @logged_in_member.id
    unless options[:super] || request.remote_ip.blank?
      ip_addresses = @logged_in_member.ip_address.to_s.split(',')
      ip_addresses << request.remote_ip
      @logged_in_member.update_attribute(:ip_address, ip_addresses.uniq.sort.join(','))
    end
    if Module.value_to_boolean(params[:in_popup])
      render(:text => "<script type='text/javascript'>window.close()</script>")
    elsif options[:redirect]
      options.reverse_merge!(:flash_notice => "Welcome back #{@logged_in_member.forename}! Thanks for logging in again.")
      flash[:notice] = options[:flash_notice] if options[:flash_notice].present?
      return redirect_to(params[:redirect_to]) if !params[:redirect_to].nil?
      if params[:iframe] || options[:iframe]
        responds_to_parent do
          render :update do |page|
            redirect_url = login_waypoint || waypoint || root_url
            if redirect_url.is_a?(Hash) && redirect_url.keys.collect(&:to_s).include?("anchor")
              redirect_url[:reload] = true
            end
            page.redirect_to(redirect_url)
          end
        end
      else
        redirect_to_waypoint_after_login
      end
    end
  end
  
  def log_out
    puts "IN log_out"
    puts "session[:logged_in_member_id] = #{session[:logged_in_member_id]}"
    if session[:logged_in_member_id]
      session[:logged_in_member_id] = nil
      @logged_in_member = nil
      flash.clear
      flash[:notice] = "The BTA website is currently undergoing some maintenance, and logging in has been temporarily disabled. Please check back again later."
      redirect_to root_url
    end
  end

end
