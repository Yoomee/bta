require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ProductPhotoTest < ActiveSupport::TestCase
  
  should have_db_column(:image_uid).of_type(:string)
  should have_timestamps

  should belong_to(:product)
  
end