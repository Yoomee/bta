module TramlinesEvents::SectionExtensions
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.has_many :events, :through => :pages
  end
  
  module ClassMethods

    def events
      s = Section.find_or_initialize_by_slug("events")
      s.update_attributes!(:name => "Events") if s.new_record?
      s
    end

  end
  
end