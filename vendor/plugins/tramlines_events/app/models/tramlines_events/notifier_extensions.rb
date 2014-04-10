module TramlinesEvents::NotifierExtensions

  def new_booking_notification(booking)
    from APP_CONFIG[:site_email]
    recipients [APP_CONFIG[:site_email], 'si@yoomee.com', 'ian@yoomee.com']
    subject "New booking on #{booking.event_name}"
    @booking = booking
    content_type  "multipart/alternative"
    part :content_type => "text/plain", :body => render_message("new_booking_notification.text.plain", {})
    part :content_type => "text/html", :body => render_message("new_booking_notification.text.html", {})
  end

end
