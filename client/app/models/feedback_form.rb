module FeedbackForm
  
  include EnquiryForm
  
  email_from "website@tinnitus.org.uk"
  email_subject 'New website feedback form submission'
  email_to "info@tinnitus.org.uk"
  fields :name, :email_address, :message
  response_message 'Thank you for your feedback'
  title "Website feedback"
  
end
