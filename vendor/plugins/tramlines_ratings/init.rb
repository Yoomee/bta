# Include hook code here
ActiveRecord::Base.class_eval do
  
  class << self
    
    def rateable_by_member
      send(:include, TramlinesRatings::RateableByMember)
    end
    
    def rateable_by_member?
      included_modules.include?(TramlinesRatings::RateableByMember)
    end
    
  end
  
  def rateable_by_member?
    self.class::rateable_by_member?
  end
  
end

%w(controllers helpers models views).each {|path| ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'app', path) }
ActiveSupport::Dependencies.load_once_paths.delete File.join(File.dirname(__FILE__), 'lib')
