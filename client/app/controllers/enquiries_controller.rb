EnquiriesController.class_eval do
  
  def create
    @enquiry = Enquiry.new(params[:enquiry])
    if @enquiry.save
      Notifier.deliver_enquiry_notification @enquiry
      flash[:notice] = "#{@enquiry.response_message}"
      redirect_to @enquiry.form_name == "report" ? @enquiry.post.topic : root_url
    else
      render :action => 'new'
    end
  end
  
  def show
    @enquiry = Enquiry.find(params[:id])
    if @enquiry.form_name == "report"
      render :action => "report"
    end
  end
  
  
end