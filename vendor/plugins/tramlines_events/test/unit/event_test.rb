require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class EventTest < ActiveSupport::TestCase

  should have_db_column(:paypal_business).of_type(:string)
  should have_db_column(:paypal_payment_amount).of_type(:float)
  should have_db_column(:use_paypal).of_type(:boolean)
  
  should have_many(:bookings)

  should_delegate :page_text, :to => :page, :object_method => :text, :nil_object_result => ''
  
  context "a future event" do
   
    setup do
      @event = Factory.build(:future_event)
    end
    
    should "return false to bookable? if APP_CONFIG[:events_bookable] is false" do
      APP_CONFIG.stubs(:[]).with(:events_bookable?).returns false
      @event.use_paypal = true
      assert !@event.bookable?
    end
    
    should "return false to bookable? if APP_CONFIG[:events_bookable] is true but doesn't use paypal" do
      APP_CONFIG.stubs(:[]).with(:events_bookable?).returns false
      @event.use_paypal = false
      assert !@event.bookable?
    end
    
    should "return true to bookable? if APP_CONFIG[:events_bookable] is true and the event uses paypal" do
      APP_CONFIG.stubs(:[]).with(:events_bookable?).returns true
      @event.use_paypal = true
      assert @event.bookable?
    end
    
  end
  
  context "a past event" do
    
    setup do
      @event = Factory.build(:past_event)
    end
    
    should "return false to bookable?" do
      APP_CONFIG.stubs(:[]).with(:events_bookable?).returns true
      assert !@event.bookable?
    end
    
  end
  
end
