Factory.define(:page_with_future_event, :parent => :page) do |p|
  p.association :event, :factory => :future_event
end

Factory.define(:page_with_past_event, :parent => :page) do |p|
  p.association :event, :factory => :past_event
end

