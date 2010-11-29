module FeedbackForm
  
  include EnquiryForm
  
  email_from "info@yoomee.com"
  email_subject 'New website feedback form submission'
  email_to "si@yoomee.com"
  fields :name, :email_address, :message
  response_message 'Thank you for your feedback'
  title "Website feedback"
  
end
