require File.dirname(__FILE__) + '/../../../test/test_helper'
class TopicsControllerTest < ActionController::TestCase
  
  should have_action(:show).with_level(:member_only)
  
end