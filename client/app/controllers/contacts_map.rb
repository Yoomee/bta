module ContactsMap

  MAP_DEFAULT_CENTER = [54.00366,-2.547855]

  private
  def initialize_map(contacts)
    @map = GMap.new("map_div")
    @map.control_init(:large_map => false, :map_type => false)
    @map.center_zoom_init(MAP_DEFAULT_CENTER, 5)
    contacts.each do |contact|
      marker = GMarker.new(contact.lat_lng, :info_window => @template.render("contacts/contact", :contact => contact))
      @map.overlay_init(marker)
    end
  end

end