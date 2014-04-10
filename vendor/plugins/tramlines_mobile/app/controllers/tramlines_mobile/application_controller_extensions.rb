module TramlinesMobile
  module ApplicationControllerExtensions
    def self.included(klass)
      klass.has_mobile_fu
      klass.before_filter :render_mobile_view_or_not
      klass.helper_method :mobile_view_exists?
      klass.helper_method :mobile_partial_exists?
      klass.alias_method_chain :render, :mobile
    end
    
    def render_with_mobile(options = nil, extra_options = {}, &block)
      if session[:mobile_view] && options != :update
        options = {:template => default_template, :layout => true } if options.nil?
        #store original format
        old_format = request.format
        #use mobile layout unless another layout explicitly given
        options[:layout] = 'application.mobile' if (!options[:layout].blank? && !options[:layout].is_a?(String))
        #render html.haml layout if no mobile.haml view exists
        request.format = mobile_view_exists?("#{controller_name}/#{action_name}") ? :mobile : :html
        @template_format = request.format.to_sym
        out = render_without_mobile(options, extra_options, &block)
        #restore original format
        request.format = old_format
        @template_format = request.format.to_sym
        out
      else
        render_without_mobile(options, extra_options, &block)
      end
    end
    
    private    
    def render_mobile_view_or_not
      if session[:mobile_view]
        request.format = :mobile
      elsif is_mobile_device? && !request.xhr?
        request.format = session[:mobile_view] == false ? :html : :mobile
        session[:mobile_view] = true if session[:mobile_view].nil?
      end
      if !request.xhr? && request.format == :mobile && !mobile_view_exists?("#{controller_name}/#{action_name}")
        request.format = :html
      end
    end
    
    def mobile_view_exists?(view_name)
      ApplicationController.view_paths.any? do |path|
        File.exists?("#{path}/#{view_name}.mobile.haml")
      end
    end
    
    def mobile_partial_exists?(partial_path)
      arr = partial_path.split('/')
      arr[arr.size - 1] = '_' + arr.last
      partial = arr.join('/')
      ApplicationController.view_paths.any? do |path|
        File.exists?("#{path}/#{partial}.mobile.haml")
      end
    end
  end
end
