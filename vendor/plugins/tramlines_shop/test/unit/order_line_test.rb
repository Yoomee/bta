require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class OrderLineTest < ActiveSupport::TestCase
  
  should belong_to(:order)
  should belong_to(:product)
  should have_db_column(:quantity).of_type(:integer).with_options(:default => 1)
  should have_db_column(:product_price_in_pence).of_type(:integer)
  
end