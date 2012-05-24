SearchController.class_eval do
  
  # Don't use autocomplete index, always returns [] on production
  def create
    options = {:match_mode => params[:match_mode], :autocomplete => false}
    @search = Search.new params[:search], options
    if request.xhr?
      partial_view_path = params[:results_view_path] ? "#{params[:results_view_path]}/" : ""
      return render(:partial => "#{partial_view_path}ajax_search_results", :locals => {:search => @search})
    end
  end

  def autocomplete
    search = Search.new({:term => params[:term], :models => params[:models]}, :autocomplete => true)
    search_results = search.results
    results = search_results.map {|result| {:label => @template.render("search/autocomplete_result", :result => result), :value => result.to_s, :url => url_for(result)}}
    render :json => results.to_json
  end
  
  #used in ckeditor link dialog
  def jquery_autocomplete
    search = Search.new({:term => params.delete(:q)}, :autocomplete => true)
    results = search.results.map {|result| {:name => "#{result.to_s} (#{result.is_a?(Page) && result.is_event? ? "Event - starts #{result.event.start_date.strftime('%d/%m/%Y')}" : result.class}#{" in <em>#{result.section}</em>" if result.is_a?(Page) && !result.is_event?})", :url => url_for(result)}}    
    results += search.non_sphinx_results.map {|result| {:name => "#{result.form_title} (Enquiry form)", :url => url_for(:controller => 'enquiries', :action => 'new', :id => result.form_name)}}
    render :json => results.to_json
  end
  
end