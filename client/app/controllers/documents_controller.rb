DocumentsController.class_eval do
  
  def show_with_analytics
    @logger = Logger.new("#{RAILS_ROOT}/log/document_referrers.log")
    @logger.info "*******************"
    @logger.info "TIME: #{Time.now}"
    @logger.info "Document id = #{@document.id}"
    @logger.info "Referrer = #{request.referrer}"
    show_without_analytics if request.referrer =~ /tinnitus\.org\.uk/i
  end
  alias_method_chain :show, :analytics
  
end