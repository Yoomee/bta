SearchController.class_eval do
  
  def autocomplete
    search = Search.new({:term => params[:term], :models => params[:models]}, :autocomplete => true)
    search_results = search.results
    results = search_results.map {|result| {:label => @template.render("search/autocomplete_result", :result => result), :value => result.to_s, :url => url_for(result)}}
    render :json => results.to_json
  end
  
end