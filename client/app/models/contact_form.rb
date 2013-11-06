module ContactForm

  include EnquiryForm
  
  title "Contact Us"
  fields :name, :email_address, :address, :phone_number, :i_would_like_more_information_because, :please_send_me_more_information_on, :please_send_this_information_to_me, :i_would_like_to_receive_regular_email_updates_from_the_bta, :message
  
  email_to "info@tinnitus.org.uk"
  email_from "website@tinnitus.org.uk"
  email_subject "New contact form enquiry"
  
  response_message "Thank you for your enquiry. We will be in touch shortly."
  
  validates_presence_of :name, :email_address, :address, :phone_number, :message, :i_would_like_more_information_because, :please_send_me_more_information_on, :please_send_this_information_to_me
  validates_format_of :email_address, :with => ValidateExtensions::EMAIL_FORMAT
  
end
