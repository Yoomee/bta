Factory.define(:payment) do |f|
  f.sequence(:reference) {|n| "#{n}"}
  f.payment_pence 1000
  f.uk_taxpayer true
  f.association :attachable, :factory => :member
end
