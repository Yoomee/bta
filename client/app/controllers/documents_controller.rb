DocumentsController.class_eval do
  
  def show_with_analytics
    show_without_analytics if request.referrer =~ /tinnitus\.org\.uk/m
  end
  alias_method_chain :show, :analytics
  
end