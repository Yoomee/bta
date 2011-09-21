ApplicationController.class_eval do

  ExceptionNotifier.email_prefix = 'BTA: '
  ExceptionNotifier.exception_recipients = 'developers@yoomee.com'

  skip_before_filter :force_password_change
  
  #before_filter :log_out
  
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
