require 'tramlines_events/asset_copier'
if RAILS_ENV == "development"
  TramlinesEvents::AssetCopier.copy "tramlines_events"
elsif RAILS_ENV == "production"
  TramlinesEvents::AssetCopier.warn "tramlines_events"
end

# make plugin controller available to app
# config.load_paths += %W(#{TramlinesEvents::PLUGIN_CONTROLLER_PATH} #{TramlinesEvents::PLUGIN_HELPER_PATH})

ActiveRecord::Base.class_eval do
  
  class << self
    
    # Takes a class as it's wall class
    def has_events
      include ::TramlinesEvents::HasEvents
    end
    
  end
  
end

%w(controllers helpers models views).each {|path| ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'app', path) }
ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'lib')