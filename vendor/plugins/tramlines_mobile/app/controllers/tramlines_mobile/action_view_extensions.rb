module TramlinesMobile
  module ActionViewExtensions
    def self.included(base)
      base.alias_method_chain :render_partial, :mobile
    end

    def render_partial_with_mobile(options = {})
      if session[:mobile_view]
        old_format = @template_format
        if mobile_partial_exists?(options[:partial])
          request.format, @template_format = :mobile, :mobile
        else
          request.format, @template_format = :html, :html
        end          
        out = render_partial_without_mobile(options)
        request.format, @template_format = old_format, old_format
        out
      else
        render_partial_without_mobile(options)
      end
    end
    
  end
end
