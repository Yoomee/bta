# require 'forwardable'
class Contact < ActiveRecord::Base
  include TramlinesImages
  
  extend Forwardable
  
  
  DEFAULT_ZOOM = 10
  
  EMAIL_FORMAT = /^[^\s]+@[^\s]+\.[a-z]{2,}$/
  URL_FORMAT = /((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\&amp;%_\.\/-~-]*)?(?!['"]))|^\s*$/

  belongs_to :category, :class_name => 'ContactCategory'
  has_location  
  
  validates_presence_of :name
  validates_format_of :email, :with => EMAIL_FORMAT, :allow_blank => true
  validates_format_of :website, :with => URL_FORMAT, :allow_blank => true
  
  alias_attribute :address, :location
  
  def_delegator :map, :div, :map_div
  
  before_create :reset_lat_lng
  before_save :reset_lat_lng_if_address_changed
  
  alias_attribute :to_s, :name
  
  search_attributes %w{name}  
  
  def map(options = {})
    return @map if @map
    @map = GMap.new('contact_map')
    if lat.nil? || lng.nil?
      @map.center_zoom_init(["51.5", "-0.116667"], 4)
    else
      @map.center_zoom_init([lat, lng], DEFAULT_ZOOM)
    end
    @map.control_init(:small_map => true)
    @map.declare_init(map_marker(options[:draggable]), 'marker')
    @map.overlay_init(Variable.new('marker'))
    if options[:dragend]
      @map.event_init(Variable.new('marker'), 'dragend', options[:dragend])
    end
    @map
  end
  
  def map_marker(draggable = false)
    if lat.nil? || lng.nil?
      marker = GMarker.new(["51.5", "-0.116667"], :draggable => draggable)  
    else
      marker = GMarker.new([lat, lng], :draggable => draggable)  
    end
    marker.enable_dragging
    marker
  end
  
  def reset_lat_lng
    fields = %w{address1 address2 city country postcode}
    lat = nil
    lng = nil
    while(lat.nil? && !fields.empty?)
      tmp_address = address.concat_fields(fields, ', ', true)
      lat, lng = Mappable::geocode(tmp_address)
      fields = fields - [fields.first]
    end
    address.update_attributes(:lat => lat, :lng => lng)
  end
  
  def reset_lat_lng_if_address_changed
    reset_lat_lng if address.changed.any? {|changed_column| changed_column.in? %w{address1 address2 city country postcode}}
  end
  
end
