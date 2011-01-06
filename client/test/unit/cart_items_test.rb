require File.dirname(__FILE__) + '/../../../test/test_helper'
class CartItemsTest < ActiveSupport::TestCase
  
  should have_db_column(:bta_member).of_type(:boolean).with_options(:default => false)
  should have_db_column(:overseas).of_type(:boolean).with_options(:default => false)
  
end