# -----------------------------------------------------------------------
#
# Copyright (c) andymayer.net Ltd, 2007-2008. All rights reserved.
 
# This software was created by andymayer.net and remains the copyright
# of andymayer.net and may not be reproduced or resold unless by prior
# agreement with andymayer.net.
#
# You may not modify, copy, duplicate or reproduce this software, or
# transfer or convey this software or any right in this software to anyone
# else without the prior written consent of andymayer.net; provided that
# you may make copies of the software for backup or archival purposes
# 
# andymayer.net grants you the right to use this software solely
# within the specification and scope of this project subject to the
# terms and limitations for its use as set out in the proposal.
# 
# You are not be permitted to sub-license or rent or loan or create
# derivative works based on the whole or any part of this code
# without prior written agreement with andymayer.net.
# 
# -----------------------------------------------------------------------
module Mappable
  
  include GeoKit::Geocoders
  include GeoKit::Mappable
  
  # Adds a set of markers to a map  
  def self.add_markers map, markers
    # Add Markers
    managed_markers = ManagedMarker.new(markers, 1, 16)
    mm = GMarkerManager.new(map, :managed_markers => [managed_markers])
    map.declare_init(mm,"mgr")
  end
  
  def self.bounding_box latlngs
    sorted_lats = latlngs.collect{|l| l[0].to_f }.compact.sort
    sorted_lngs = latlngs.collect{|l| l[1].to_f }.compact.sort
    bounds = Geokit::Bounds.new(Geokit::LatLng.new(sorted_lats.first, sorted_lngs.last), Geokit::LatLng.new(sorted_lats.last, sorted_lngs.first))
    # centre = midpoint_between([sorted_lats.first, sorted_lngs.last], [sorted_lats.last, sorted_lngs.first]).to_s.split(",")
    # {:lat => centre[0], :lng => centre[1], :sw_lat => sorted_lats.first, :sw_lng => sorted_lngs.last, :ne_lat => sorted_lats.last, :ne_lng => sorted_lngs.first}
  end
  
  # Creates a map  with markers for each item
  # Options include:
  # :map_id => The id of the map in use
  # :large_map => true || false => Scale on map
  # :map_type => true || false => Change between map types (satellite, hybrid, map)
  # block is passed the markers so that you can define what is shown in the bubble  
  #
  # Example use:
  # @map = Mappable::create_map @members, {:map_id => 'map_canvas', :large_map => true, :map_type => true} do |member|
  #  Mappable::marker_from_address member.get_gm_address, "#{member.business}<br/>#{member.get_gm_address}<br/><a href='/member/show/#{member.id}'>More</a>"
  # end
  def self.create_map items, options, &block
    # Create Map
    map = GMap.new(options[:map_id] || 'map_canvas')
    map.control_init(options)
    
    # Add point for each item
    markers = []
    locations = []
    
    for item in items
      marker = yield item if block_given?
      raise "Must return a marker" unless marker.class == GMarker
      markers << marker
      locations << marker.point
    end
    
    if options[:center].is_a?(Symbol) && options[:center] == :points
      set_center_of_points(map, locations)
    elsif options[:center].is_a?(Hash)
      set_center(map, options[:center])
    end
    add_markers(map, markers)  
    map
  end
  
  def self.geocode address
    addr = GoogleGeocoder.geocode(address)
    return addr.lat, addr.lng
  end
  
  def self.icon pic
    GIcon.new(:image => pic)
  end
  
  # Includes the methods under ClassMethods in the including
  # class
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  # Creates a marker from a latitude and longitude with html
  # in the bubble
  def self.marker lat, lng, html
    GMarker.new(GLatLng.new([lat, lng]), :info_window => html)
  end
  
  # Encodes an address and creates a marker
  # html is the html shown in the bubble
  def self.marker_from_address address, html
    lat, lng = self.geocode(address)
    self.marker lat, lng, html
  end
  
  def self.reverse_geocode latlng
    res = GoogleGeocoder.reverse_geocode(latlng)
    return res
  end
  
  # Set center to specific points
  def self.set_center map, options
    map.center_zoom_init(GLatLng.new([options[:lat], options[:lng]]), options[:zoom])
  end

  # Sets the center of the map to the center of the points
  def self.set_center_of_points map, points
    # Set the center and zoom
    sorted_latitudes = points.collect{|p| p.lat.to_f }.compact.sort
    sorted_longitudes = points.collect{|p| p.lng.to_f }.compact.sort
    map.center_zoom_on_bounds_init([
      [sorted_latitudes.first, sorted_longitudes.last], 
      [sorted_latitudes.last, sorted_longitudes.first]])
  end
  
  def self.set_icon marker, icon
    marker.options.update({:icon => icon})
    marker
  end
  
  module ClassMethods
    
    # include Mappable in model
    # Make method get_marker that returns a GMarker for that instance
    # @map = Member.map_all({:member_type => 'business'}, {:large_map => true, :map_type => true})
    
    def map_all conditions, map_options
      Map::create_map self.find(:all, conditions), map_options do |item|
        item.get_marker
      end
    end
    
  end
  
  def marker_with_icon lat, lng, html, pic
    marker = self.marker(lat, lng, html)
    icon = self.icon pic
    self.set_icon marker, icon
  end
  
end
