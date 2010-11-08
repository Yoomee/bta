require File.dirname(__FILE__) + '/../../../test/test_helper'
class ProductTest < ActiveSupport::TestCase
  
  should have_db_column(:member_special_offer).of_type(:text)
  
end