require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class RatingTest < ActiveSupport::TestCase

  should belong_to(:member)
  should belong_to(:rateable)
  
end