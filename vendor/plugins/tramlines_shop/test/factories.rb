Factory.define(:cart) do |c|
end

Factory.define(:cart_item) do |ci|
  ci.association :cart
  ci.association :product
  ci.quantity 1
end

Factory.define(:department) do |d|
  d.name 'A department'
end

Factory.define(:deleted_department, :parent => :department) do |d|
  d.deleted_at 1.day.ago
end

Factory.define(:order) do |f|
  f.created_at Time.now
end

Factory.define(:product) do |f|
  f.association(:department)
  f.name 'Pencil sharpener'
  f.price_in_pence 999
  if Tramlines.uses_plugin?(:walls)
    f.after_build do |p|
      wall = Factory.build(:wall)
      p.stubs(:wall).returns wall
      wall.stubs(:attachable).returns p
    end
  end
end

Factory.define(:deleted_product, :parent => :product) do |p|
  p.deleted_at 1.day.ago
end

Factory.define(:product_photo) do |f|
end