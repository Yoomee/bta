module TramlinesEvents::PageExtensions
  
  def self.included(klass)
    klass.alias_method_chain :form_tabs, :events
    klass.alias_method_chain :loaded_tabs, :events
    klass.alias_method_chain :type_name, :event
    klass.delegate :end_at, :to => :event, :prefix => true, :allow_nil => true
    klass.delegate :has_address?, :to => :event, :prefix => true, :allow_nil => true    
    klass.delegate :has_location?, :to => :event, :prefix => true, :allow_nil => true
    klass.delegate :paypal_business, :to => :event, :prefix => true, :allow_nil => true
    klass.delegate :paypal_business=, :to => :event, :prefix => true
    klass.delegate :paypal_payment_amount, :to => :event, :prefix => true, :allow_nil => true
    klass.delegate :paypal_payment_amount=, :to => :event, :prefix => true
    klass.delegate :same_day?, :to => :event, :prefix => true, :allow_nil => true    
    klass.delegate :start_at, :to => :event, :prefix => true, :allow_nil => true
    klass.delegate :use_paypal=, :to => :event, :prefix => true
    klass.has_one :event, :dependent => :destroy, :autosave => true
    klass.validates_format_is_email_address_of :event_paypal_business, :if => Proc.new{|page| page.event_use_paypal?}
    klass.named_scope :future, lambda{{:joins => :event, :conditions => ["events.start_at >= ?", Time.zone.now]}}
    klass.named_scope :event_order, :joins => :event, :select => 'events.start_at', :order => 'start_at'
    klass.named_scope :not_past_events, lambda {{:joins => "LEFT JOIN events ON events.page_id=pages.id", :conditions => ["events.start_at > ? OR events.start_at IS NULL", Time.zone.now]}}
    klass.named_scope :not_events, :joins => "LEFT JOIN events ON events.page_id=pages.id", :conditions => "events.id IS NULL"
  end

  def event_attributes=(attributes)
    event ? self.event.attributes = attributes : self.build_event(attributes)
  end
  
  def event_bookable?
    has_event? ? event.bookable? : false
  end
  
  def event_bookings
    has_event? ? event.bookings : []
  end
  
  def event_in_future?
    event.try(:in_future?)
  end

  def event_use_paypal?
    has_event? ? event.use_paypal? : false
  end
  alias_method :event_use_paypal, :event_use_paypal?

  def form_tabs_with_events
    has_event? ? form_tabs_without_events + %w{paypal} : form_tabs_without_events
  end
  
  def has_event
    !event.nil? || @has_event
  end
  alias_method :has_event?, :has_event
  alias_method :is_event, :has_event
  alias_method :is_event?, :has_event
  
  def has_event=(value)
    @has_event = value
    if @has_event
      self.build_event
      self.section ||= Section.events
    end
  end
  
  def loaded_tabs_with_events
    has_event? ? loaded_tabs_without_events + %w{paypal location} : loaded_tabs_without_events
  end
  
  def type_name_with_event
    event ? "event" : type_name_without_event
  end
  
end

