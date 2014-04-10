class ProductPhoto < ActiveRecord::Base
  
  include TramlinesImages
  
  belongs_to :product
  
end