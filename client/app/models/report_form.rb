module ReportForm

  include EnquiryForm
  
  title "Report this post as inappropriate"
  fields :post_id, :message
  
  email_to "info@tinnitus.org.uk"
  email_from "website@tinnitus.org.uk"
  email_subject "New inappropriate post report"
  
  response_message "Thank you for reporting this post."
  
  validates_presence_of :post_id, :message
  
  def email
    member.try(:email)
  end
  
  def post
    @post ||= Post.find_by_id(post_id)
  end
  
  def post=(val)
    self.post_id = val.try(:id)
  end
  
end
