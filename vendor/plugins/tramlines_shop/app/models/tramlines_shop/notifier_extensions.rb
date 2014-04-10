module TramlinesShop::NotifierExtensions
  
  def order_confirmation(order)
    recipients order.email
    from APP_CONFIG['site_email']
    subject "#{APP_CONFIG['site_name']} - Order confirmation"
    @order = order
    content_type  "multipart/alternative"
    part :content_type => "text/plain", :body => render_message("order_confirmation.text.plain", {})
    part :content_type => "text/html", :body => render_message("order_confirmation.text.html", {})
  end
  
end