DocumentsController.class_eval do
  
  def show_with_analytics
    @logger = Logger.new("#{RAILS_ROOT}/log/document_referrers.log")
    @logger.info "*******************"
    @logger.info "TIME: #{Time.now}"
    @logger.info "Document id = #{@document.id}"
    @logger.info "Referrer = #{request.referrer}"
    # If the link has come from the website, or t is within the past minute
    show_without_analytics if (request.referrer =~ /tinnitus\.org\.uk/i) || (params[:t] && params[:t].to_i  > 1.minute.ago.to_i)
  end
  alias_method_chain :show, :analytics
  
end