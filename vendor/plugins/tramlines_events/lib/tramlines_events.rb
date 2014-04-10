module TramlinesEvents

  def self.included(klass)
    PagesController.send(:include, TramlinesEvents::PagesControllerExtensions)
    SectionsController.send(:include, TramlinesEvents::SectionsControllerExtensions)
    Page.send(:include, TramlinesEvents::PageExtensions)
    Section.send(:include, TramlinesEvents::SectionExtensions)
    Notifier.send(:include, TramlinesEvents::NotifierExtensions)
  end
  
  module HasEvents
    
    def self.included(klass)
      klass.has_many :events, :as => :attachable
    end
    
  end
  
end
