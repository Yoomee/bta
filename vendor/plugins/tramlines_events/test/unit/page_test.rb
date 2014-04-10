require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class PageTest < ActiveSupport::TestCase

  should_delegate :event_bookable?, :to => :event, :object_method => :bookable?, :nil_object_result => false
  should_delegate :event_bookings, :to => :event, :object_method => :bookings, :nil_object_result => []
  should_delegate :event_paypal_business, :to => :event, :object_method => :paypal_business
  should_delegate :event_paypal_business=, :to => :event, :object_method => :paypal_business=
  should_delegate :event_paypal_payment_amount, :to => :event, :object_method => :paypal_payment_amount
  should_delegate :event_paypal_payment_amount=, :to => :event, :object_method => :paypal_payment_amount=
  should_delegate :event_use_paypal, :to => :event, :object_method => :use_paypal?, :nil_object_result => false
  should_delegate :event_use_paypal=, :to => :event, :object_method => :use_paypal=
  should_delegate :event_use_paypal?, :to => :event, :object_method => :use_paypal?, :nil_object_result => false
  
  context "a page with a future event" do
    
    setup do
      @page = Factory.create(:page_with_future_event)
    end

    should 'return true to event_in_future?' do
      assert @page.event_in_future?
    end
   
  end
  
  context "a page with a past event" do
    
    setup do
      @page = Factory.create(:page_with_past_event)
    end
    
    should 'return false to event_in_future?' do
      assert !@page.event_in_future?
    end
    
  end
  
  context "a page without an event" do
    
    setup do
      @page = Factory.create(:page)
    end
    
    should 'return false to event_in_future?' do
      assert !@page.event_in_future?
    end
    
  end
  
  context "class on call to not_past_events" do
    
    should "not return a page with an event in the past" do
      @page = Factory.create(:past_event).page
      assert_does_not_contain Page.not_past_events, @page
    end
    
    should "return a page with an event in the future" do
      @page = Factory.create(:future_event).page
      assert_contains Page.not_past_events, @page
    end
    
    should "return a page without an event" do
      @page = Factory.create(:page)
      assert_contains Page.not_past_events, @page
    end
    
  end
  
end

