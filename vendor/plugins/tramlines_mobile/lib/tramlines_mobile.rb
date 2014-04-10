module TramlinesMobile
  def self.included(klass)
    ApplicationController.send(:include, TramlinesMobile::ApplicationControllerExtensions)
    ActionView::Partials.send(:include, TramlinesMobile::ActionViewExtensions)
    ActionController::MobileFu::InstanceMethods.send(:include, MobileFuExtensions)
  end
end
