module MapsHelper
  
  def contact_us_map
    content_tag(:iframe, "", :width=>"425", :height=>"350", :frameborder=>"0", :scrolling=>"no", :marginheight=>"0", :marginwidth=>"0", :src=>"http://maps.google.co.uk/maps/ms?f=q&source=s_q&hl=en&geocode=&ie=UTF8&hq=&hnear=Sheffield,+South+Yorkshire+S8+0TB,+United+Kingdom&msa=0&msid=110139359696726151215.000496bddeee7558d77be&ll=53.488046,-1.494141&spn=2.268203,4.669189&z=7&output=embed")
  end
  
  def contact_us_map_url
"http://maps.google.co.uk/maps/ms?f=q&source=s_q&hl=en&geocode=&ie=UTF8&hq=&hnear=Sheffield,+South+Yorkshire+S8+0TB,+United+Kingdom&msa=0&msid=110139359696726151215.000496bddeee7558d77be&ll=53.488046,-1.494141&spn=2.268203,4.669189&z=7&output=embed"
  end
end