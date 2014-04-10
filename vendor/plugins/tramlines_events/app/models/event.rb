class Event < ActiveRecord::Base

  belongs_to :attachable, :polymorphic => true
  belongs_to :page
  belongs_to :category, :class_name => "EventCategory"

  has_many :bookings
  
  has_event_calendar
  
  default_scope :order => 'start_at'

  named_scope :before, lambda{|time| {:conditions => ["start_at < ?", time]}}
  named_scope :closest, :order => "start_at DESC"
  named_scope :earliest_first, :order => 'start_at, end_at'
  named_scope :future, lambda{{:conditions => ["end_at >= ? OR start_at >= ? ", Date.today, Date.today]}}
  named_scope :on_date, lambda{|date| {:conditions => ["events.start_at >= ? AND events.end_at <= ?", date.to_time, date.tomorrow.to_time]}}
  named_scope :published, lambda{{:joins => :page, :conditions => ["pages.publish_on <= :now AND pages.expires_on > :now AND pages.draft = 0", {:now => Time.zone.now}]}}
  named_scope :with_category_ids, lambda{|category_ids| {:conditions => ["events.category_id IN (?)", category_ids]}}

  formatted_time_accessor :start_at, :end_at
  
  validates_presence_of :end_at, :start_at
  validates_format_is_email_address_of :paypal_business, :if => Proc.new{|event| event.use_paypal?}
  
  def bookable?
    APP_CONFIG[:events_bookable?] && in_future? && use_paypal?
  end

  def color
    category.nil? ? '#000' : category.color
  end

  def description
    page.intro || page.text
  end
  
  def end_date
    end_at.to_date
  end

  def has_terms_and_conditions?
    !terms_and_conditions.blank?
  end

  def in_future?
    start_at > Time.zone.now
  end
  
  def formatted_start_date
    start_at.try(:strftime, '%d/%m/%Y')
  end
  
  def formatted_start_date=(value)
    self.formatted_start_at = "#{value} 00:00"
  end

  def formatted_end_date
    end_at.try(:strftime, '%d/%m/%Y')
  end
  
  def formatted_end_date=(value)
    self.formatted_end_at = "#{value} 00:00"
  end
  
  def initialize_with_defaults(attrs = {})
    initialize_without_defaults(attrs) do
      self.start_at ||= Time.zone.now
      self.end_at ||= start_at + 1.hour
    end
  end
  alias_method_chain :initialize, :defaults

  def name
    page.to_s
  end
 
  def page_text
    page.try(:text) || ''
  end
 
  def same_day?
    start_date == end_date
  end
  
  def start_date
    start_at.to_date
  end

  def terms_and_conditions
    page.snippet_terms_and_conditions
  end

  def to_s
    name
  end

end
    
