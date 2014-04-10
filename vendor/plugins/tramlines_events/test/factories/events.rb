Factory.define(:future_event, :class => Event) do |e|
  e.end_at 2.hours.from_now
  e.association(:page)
  e.start_at 1.hour.from_now
end

Factory.define(:past_event, :class => Event) do |e|
  e.end_at 13.hours.ago
  e.association(:page)
  e.start_at 1.day.ago
end
