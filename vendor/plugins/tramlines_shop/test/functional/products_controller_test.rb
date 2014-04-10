require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ProductsControllerTest < ActionController::TestCase
  
  should have_action(:create).with_level(:admin_only)
  should have_action(:destroy).with_level(:admin_only)
  should have_action(:edit).with_level(:admin_only)
  should have_action(:new).with_level(:admin_only)
  should have_action(:show).with_level(:open)
  should have_action(:update).with_level(:admin_only)

  context "create action with invalid attributes" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:new).returns @product
      @product.stubs(:save).returns false
    end
    
    context "POST" do
      
      setup do
        stub_access
        post :create, :product => {:valid_attributes => false}
      end
      
      before_should "initialize the product" do
        Product.expects(:new).with('valid_attributes' => false).returns @product
      end
      
      before_should "attempt to save the product" do
        @product.expects(:save).returns false
      end
      
      should assign_to(:product).with {@product}
      
      should render_template(:new)
      
    end
    
  end

  context "create action with valid attributes" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:new).returns @product
      @product.stubs(:save).returns true
    end
    
    context "POST" do
      
      setup do
        stub_access
        post :create, :product => {:valid_attributes => true}
      end
      
      before_should "initialize the product" do
        Product.expects(:new).with('valid_attributes' => true).returns @product
      end
      
      before_should "save the product" do
        @product.expects(:save).returns true
      end
      
      should respond_with(:redirect)
      
    end
    
  end
        
  context "destroy action" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:find).with('123').returns @product
      @product.stubs(:destroy).returns true
      @department = Factory.build(:department, :id => 456)
      @product.stubs(:department).returns @department
    end
    
    context "DELETE" do
      
      setup do
        stub_access
        delete :destroy, :id => 123
      end
  
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "destroy the product" do
        @product.expects(:destroy).returns true
      end
      
      
    end
    
  end
  
  context "edit action" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:find).with('123').returns @product
      Product.stubs(:find).with {|*args| args.first == :all}.returns [@product]      
    end
    
    context "GET" do
      
      setup do
        stub_access
        get :edit, :id => 123
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
    
      should render_template(:edit)
      
    end
    
  end
  
  context "new action" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:new).returns @product
    end
    
    context "GET with department_id" do
      
      setup do
        stub_access
        get :new, :department_id => 123
      end
      
      before_should "initialize the product" do
        Product.expects(:new).with {|*args| args.first[:department_id] == '123'}.returns @product
      end
      
      should assign_to(:product).with {@product}
      
      should render_template(:new)
      
    end
    
  end
  
  context "show action" do
    
    setup do
      @product = Factory.build(:product, :id => 123)
      Product.stubs(:find).with('123').returns @product
      Product.stubs(:find).with {|*args| args.first == :all}.returns [@product]
    end
    
    context "GET" do
      
      setup do
        get :show, :id => 123
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      should render_template(:show)
      
    end
    
  end

  context "update action with invalid attributes" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:find).with('123').returns @product
      Product.stubs(:find).with {|*args| args.first == :all}.returns [@product]      
      @product.stubs(:update_attributes).returns false
    end
    
    context "PUT" do
      
      setup do
        stub_access
        put :update, :id => 123, :product => {:valid_attributes => false}
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "update the product" do
        @product.expects(:update_attributes).with('valid_attributes' => false).returns false
      end
      
      should assign_to(:product).with {@product}
      should render_template(:edit)
      
    end
    
  end

  context "update action with valid attributes" do
    
    setup do
      @product = Factory.build(:product)
      Product.stubs(:find).with('123').returns @product
      Product.stubs(:find).with {|*args| args.first == :all}.returns [@product]      
      @product.stubs(:update_attributes).returns true
    end
    
    context "PUT" do
      
      setup do
        stub_access
        put :update, :id => 123, :product => {:valid_attributes => true}
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "update the product" do
        @product.expects(:update_attributes).with('valid_attributes' => true).returns true
      end
      
      should assign_to(:product).with {@product}
      should respond_with(:redirect)
      
    end
    
  end
  
end
