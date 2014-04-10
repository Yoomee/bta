require File.dirname(__FILE__) + '/../../../../test/test_helper'

class TramlinesEventsTest < ActiveSupport::TestCase

  context "ActiveRecord::Base" do
    
    should "have a has_events class method" do
      assert_respond_to ActiveRecord::Base, :has_events
    end
    
  end
  
  # context "Page" do
  #   
  #   should "have one event" do
  #     assert_respond_to Page, :event
  #   end
  #   
  # end

end
