Mime::Type.register_alias "text/html", :mobile
%w(controllers helpers models views).each {|path| ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'app', path) }
ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'lib')

ActionView::Base.class_eval do
  def render_with_mobile(*args, &block)
    if !controller.is_a?(ActionMailer::Base) && session[:mobile_view] && !args[0][:partial].nil?
      partial_name = args[0][:partial]
      if !partial_name.blank?
        args[0][:partial] = partial_name + ".html" unless (partial_name.ends_with?(".html") || mobile_partial_exists?(partial_name))
      end
    end
    render_without_mobile(*args, &block)
  end
  alias_method_chain :render, :mobile
end