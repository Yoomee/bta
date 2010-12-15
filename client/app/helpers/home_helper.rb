module HomeHelper

  def render_carousel_button(page)
    text = page.has_snippet?(:carousel_button_text) ? snippet(page, :carousel_button_text) : "Find out more"
    link_to(text, page, :class => 'learn_more_bttn bttn_round')
  end
  
  def render_carousel_quote(page)
    options = {}
    quote = snippet(page, :carousel_quote, false).strip
    if quote.starts_with?("\"")
      quote = quote.sub("\"", "<span id='quote_start'>\"</span>")
      options[:class] = "quote"
    end
    quote = quote.chomp("\"") + "<span id='quote_end'>\"</span>" if quote.ends_with?("\"")
    content_tag(:h3, quote, options)
  end
  
end