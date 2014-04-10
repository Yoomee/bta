require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class CartsControllerTest < ActionController::TestCase
  
  should route(:get, "/cart").to(:action => 'show')
  
  should have_action(:show).with_level(:open)
  
  context "show" do
    
    setup do
      @cart = Factory.build(:cart)
      @controller.stubs(:find_cart).returns @cart
    end
    
    context "GET" do
      
      setup do
        get :show
      end
      
      before_should "get the cart" do
        @controller.expects(:find_cart).returns @cart
      end
        
      should render_template(:show)
      
    end
    
  end

  context "update action with invalid attributes" do

     setup do
       @cart = Factory.build(:cart)
       @controller.stubs(:find_cart).returns @cart
       @cart.stubs(:update_attributes).returns false
     end

     context "PUT" do

       setup do
         stub_access
         put :update, :cart => {:valid_attributes => false}
       end

       before_should "find the cart" do
         @controller.expects(:find_cart).returns @cart
       end

       before_should "attempt to update the cart" do
         @cart.expects(:update_attributes).with('valid_attributes' => false).returns false
       end

       should render_template(:show)

     end

   end

   context "update action with valid attributes" do

     setup do
       @cart = Factory.build(:cart)
       @controller.stubs(:find_cart).returns @cart
       @cart.stubs(:update_attributes).returns true
     end

     context "PUT" do

       setup do
         stub_access
         put :update, :cart => {:valid_attributes => true}
       end

       before_should "find the cart" do
         @controller.expects(:find_cart).returns @cart
       end

       before_should "update the cart" do
         @cart.expects(:update_attributes).with('valid_attributes' => true).returns true
       end

       should render_template(:show)

     end

   end  

end