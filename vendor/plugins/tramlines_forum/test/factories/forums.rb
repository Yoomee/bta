Factory.define(:forum) do |f|
  f.sequence(:title) {|n| "Forum #{n}"}
end