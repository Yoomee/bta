require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class OrdersControllerTest < ActionController::TestCase
  
  should have_action(:create).with_level(:open)
  should have_action(:new).with_level(:open)
  should have_action(:show).with_level(:open)

  context "create when using paypal" do
    
    setup do
      @cart = Factory.build(:cart)
      @controller.stubs(:cart).returns @cart
      @controller.stubs(:uses_paypal?).returns true
    end
    
    context "POST" do
      
      setup do
        post :create
      end
      
      before_should "find the cart" do
        @controller.expects(:cart).returns @cart
      end
      
      before_should "get the cart's PayPal URL" do
        @cart.expects(:paypal_url).returns "http://the.paypal.url"
      end

      should respond_with(:redirect)
      
    end
    
  end
  
  context "create when using SAGEPAY" do
    
    #TODO
    
  end
  
  context "new" do
    
    setup do
      @cart = Factory.build(:cart)
      @controller.stubs(:find_cart).returns @cart
    end
    
    context "GET" do
      
      setup do
        get :new
      end
      
      before_should "find the cart" do
        @controller.expects(:find_cart).returns @cart
      end
     
      should render_template(:new)
      should set_waypoint
      
    end
    
  end

  context "show" do
    
    setup do
      @order = Factory.build(:order)
      Order.stubs(:find).returns @order
    end
    
    context "GET" do
      
      setup do
        get :show, {:id => 'abc123'}, :cart_id => 123
      end
      
      before_should "find the order" do
        Order.expects(:find).with('abc123').returns @order
      end
      
      should render_template(:show)
      
    end
    
  end
  
  context "show when using paypal" do
  
    setup do
      @cart = Factory.build(:cart)
      @controller.stubs(:find_cart).returns @cart
      @cart.stubs(:destroy).returns true
    end
    
    context "GET" do
      
      setup do
        get :show, {:id => 'paypal'}, :cart_id => 123
      end

      before_should "find the cart" do
        @controller.expects(:find_cart).returns @cart
      end
      
      before_should "destroy the cart" do
        @cart.expects(:destroy).returns true
      end

      should set_session(:cart_id).to(nil)
      
    end

  end
  
end
