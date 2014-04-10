Factory.define(:topic) do |f|
  f.association :forum, :factory => :forum
  f.association :member, :factory => :member 
end