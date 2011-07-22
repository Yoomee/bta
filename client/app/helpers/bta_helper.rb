module BtaHelper
  
  def document_urls
    Document.all.inject({}) do |memo, doc|
      memo[doc.id] = doc.url_for_file
      memo
    end
  end
  
end