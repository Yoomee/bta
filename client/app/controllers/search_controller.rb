SearchController.class_eval do
  
  def autocomplete
    search = Search.new({:term => params[:term], :models => params[:models]}, :autocomplete => true)
    search_results = search.results
    results = search_results.map {|result| {:label => @template.render("search/autocomplete_result", :result => result), :value => result.to_s, :url => url_for(result)}}
    render :json => results.to_json
  end
  
  #used in ckeditor link dialog
  def jquery_autocomplete
    search = Search.new({:term => params.delete(:q)}, :autocomplete => true)
    results = search.results.map {|result| {:name => "#{result.to_s} (#{result.class}#{" in <em>#{result.section}</em>" if result.is_a?(Page)})", :url => url_for(result)}}
    results += search.non_sphinx_results.map {|result| {:name => "#{result.form_title} (Enquiry form)", :url => url_for(:controller => 'enquiries', :action => 'new', :id => result.form_name)}}
    render :json => results.to_json
  end
  
end