SessionsController.class_eval do
  def create_fb
    if current_facebook_user
      process_login_fb
      login_member!(@logged_in_member)
    else
      redirect_hash = waypoint || {}
      redirect_to redirect_hash.merge(:denied_fb_perms => true)
    end
  end
end