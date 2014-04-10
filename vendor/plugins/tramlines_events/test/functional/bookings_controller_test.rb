require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class BookingsControllerTest < ActionController::TestCase
  
  should have_action(:new).with_default_level(:open)
  
  context "create action with invalid attributes" do
    
    setup do
      @event = Factory.build(:future_event)
      Event.stubs(:find).returns @event
      @event.stubs(:bookable?).returns true
      @booking = Factory.build(:booking, :event_id => 123)
      Booking.stubs(:new).returns @booking
      @booking.stubs(:save).returns false
    end
    
    context 'POST' do
      
      setup do
        logged_in_member = expect_logged_in_member
        Member.stubs(:find).returns logged_in_member
        Member.stubs(:find).with {|*args| args.first == :all}.returns [logged_in_member]
        post :create, :booking => @booking.attributes
      end
      
      before_should 'find the event' do
        Event.expects(:find).with(123).returns @event
      end
      
      before_should 'call the create action if the event is bookable' do
        @event.expects(:bookable?).returns true
        @controller.expects(:create).returns true
        # STUB OUT RENDER
        @controller.stubs(:render).returns true
      end
      
      before_should 'not call the create action if the event is not bookable' do
        @event.expects(:bookable?).at_least_once.returns false
        @controller.expects(:create).never
      end
      
      before_should "initialize the booking" do
        Booking.expects(:new).with(@booking.attributes).returns @booking
      end
      
      before_should "attempt to save the booking" do
        @booking.expects(:save).returns false
      end
      
      should assign_to(:booking).with {@booking}
      should assign_to(:event).with {@event}
      should render_template(:new)
      
    end
    
  end
  
  context "create action with valid attributes" do
    
    setup do
      @event = Factory.build(:future_event)
      Event.stubs(:find).returns @event
      @event.stubs(:bookable?).returns true
      @booking = Factory.build(:booking, :event_id => 123)
      Booking.stubs(:new).returns @booking
      @booking.stubs(:save).returns true
    end
    
    context 'POST' do
      
      setup do
        logged_in_member = expect_logged_in_member
        Member.stubs(:find).returns logged_in_member
        Member.stubs(:find).with {|*args| args.first == :all}.returns [logged_in_member]
        post :create, :booking => @booking.attributes
      end
      
      before_should "find the event" do
        Event.expects(:find).with(123).returns @event
      end
      
      before_should "call the create action if the event is bookable" do
        @event.expects(:bookable?).returns true
        @controller.expects(:create).returns true
        # STUB OUT RENDER
        @controller.stubs(:render).returns true
      end
      
      before_should "not call the create action if the event is not bookable" do
        @event.expects(:bookable?).at_least_once.returns false
        @controller.expects(:create).never
      end
      
      before_should "initialize the booking" do
        Booking.expects(:new).with(@booking.attributes).returns @booking
      end
      
      before_should "save the booking" do
        @booking.expects(:save).returns true
      end
      
      should respond_with(:redirect)
      
    end
    
  end
  
  context "new action" do
    
    setup do
      @event = Factory.build(:future_event)
      @event.stubs(:bookable?).returns true
      @booking = Factory.build(:booking, :event => @event)
      Booking.stubs(:new).returns @booking
      Event.stubs(:find).returns @event
    end
    
    context "GET" do
      
      setup do
        logged_in_member = expect_logged_in_member
        Member.stubs(:find).returns logged_in_member
        get :new, :event_id => 123
      end
      
      before_should "find the event" do
        Event.expects(:find).with('123').returns @event
      end
      
      before_should "call the new action if the event is bookable" do
        @event.expects(:bookable?).returns true
        @controller.expects(:new).returns true
        # STUB OUT RENDER
        @controller.stubs(:render).returns true
      end
      
      before_should "not call the new action if the event is not bookable" do
        @event.expects(:bookable?).at_least_once.returns false
        @controller.expects(:new).never
      end
   
      before_should "initialize the booking with the event" do
        Booking.expects(:new).with(:event => @event).returns @booking
      end
      
      should assign_to(:event).with {@event}
      should assign_to(:booking).with {@booking}
      should render_template(:new)
      
    end
    
  end
  
end
