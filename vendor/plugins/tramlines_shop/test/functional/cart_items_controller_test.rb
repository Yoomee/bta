require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class CartItemsControllerTest < ActionController::TestCase
  
  should route(:post, "/cart_items").to(:action => 'create')
  
  should have_action(:create).with_level(:open)
  should have_action(:destroy).with_level(:open)
  
  context "create action" do
    
    setup do
      @cart = Factory.build(:cart)
      @controller.stubs(:find_cart).returns @cart
      @cart_item = Factory.build(:cart_item)
      @items_mock = mock
      @cart.stubs(:items).returns @items_mock
      @items_mock.stubs(:find_or_initialize_by_product_id).returns @cart_item
      @cart_item.stubs(:add_quantity).returns 5
      @cart_item.stubs(:save).returns true
    end
    
    context "POST" do
      
      setup do
        stub_access
        post :create, :cart_item => {:product_id => 123, :quantity => 5}
      end
      
      before_should "find or initialize the cart item" do
        @items_mock.expects(:find_or_initialize_by_product_id).with(123).returns @cart_item
      end
      
      before_should "set the quantity" do
        @cart_item.expects(:add_quantity).with(5).returns 5
      end

      before_should "save the cart item" do
        @cart_item.expects(:save).returns true
      end
      
      should assign_to(:cart_item).with {@cart_item}
      
      should redirect_to("cart")
      
    end
    
  end

  context "destroy" do
    
    setup do
      @cart_item = Factory.build(:cart_item)
      CartItem.stubs(:find).returns @cart_item
      @cart_item.stubs(:destroy).returns true
      @cart = Factory.build(:cart)
      @controller.stubs(:find_cart).returns @cart
      @member = Factory.build(:member)
      @controller.stubs(:logged_in_member).returns @member
      @cart.stubs(:contains_item?).returns true
    end
    
    context "delete" do
      
      setup do
        delete :destroy, :id => 123
      end
      
      before_should "find the cart_item" do
        CartItem.expects(:find).with('123').returns @cart_item
      end
      
      before_should "check the cart_item belongs to the user" do
        @cart.expects(:contains_item?).with(@cart_item).returns true
      end
      
      before_should "destroy the item" do
        @cart_item.expects(:destroy).returns true
      end
      
      should redirect_to("/cart")
      
    end
    
  end

end