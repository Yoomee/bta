Factory.define(:forum_ranking) do |f|
  f.sequence(:name) {|n| "Forum ranking #{n}"}
end