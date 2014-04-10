require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ProductPhotosControllerTest < ActionController::TestCase
  
  should have_action(:create).with_level(:admin_only)
  should have_action(:destroy).with_level(:admin_only)
  should have_action(:index).with_level(:admin_only)
  should have_action(:new).with_level(:admin_only)

  context "new" do
    
    setup do
      stub_access
      @product = Factory.build(:product)
      Product.stubs(:find).returns @product
      @photo = Factory.build(:product_photo)
      @product.stubs_path("photos.build").returns @photo
    end
    
    context "GET" do
      
      setup do
        get :new, :product_id => 123
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "build a new photo" do
        @product.expects(:photos).returns mock(:build => @photo)
      end
      
      should assign_to(:product).with {@product}
      should assign_to(:photo).with {@photo}
      
      should render_template(:new)
      
    end
    
  end

  context "create with invalid attributes" do
    
    setup do
      stub_access
      @attributes = Factory.attributes_for(:product_photo)
      @product = Factory.build(:product)
      Product.stubs(:find).returns @product
      @photo = Factory.build(:product_photo)
      @product.stubs_path("photos.build").returns @photo
      @photo.stubs(:save).returns false
    end
    
    context "POST" do
      
      setup do 
        post :create, :product_photo => @attributes, :product_id => 123
      end

      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "build the photo" do
        photos_mock = mock
        @product.expects(:photos).returns photos_mock
        photos_mock.expects(:build).with(@attributes).returns @photo
      end
      
      before_should "attempt to save the product" do
        @photo.expects(:save).returns false
      end
      
      should render_template(:new)
      
    end
    
  end

  context "create with valid attributes" do
    
    setup do
      stub_access
      @attributes = Factory.attributes_for(:product_photo)
      @product = Factory.build(:product, :id => 123)
      Product.stubs(:find).returns @product
      @photo = Factory.build(:product_photo)
      ProductPhoto.stubs(:new).returns @photo
      @photo.stubs(:save).returns true
    end
    
    context "POST" do
      
      setup do 
        post :create, :product_photo => @attributes, :product_id => 123
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "build the photo" do
        photos_mock = mock
        @product.expects(:photos).returns photos_mock
        photos_mock.expects(:build).with(@attributes).returns @photo
      end
      
      before_should "save the product" do
        @photo.expects(:save).returns true
      end
      
      should respond_with(:redirect)
      
    end
    
  end
    
  context "index" do
    
    setup do
      stub_access
      @product = Factory.build(:product, :id => 123)
      Product.stubs(:find).returns @product
      @photos = [Factory.build(:product_photo), Factory.build(:product_photo)]
      @product.stubs(:photos).returns @photos
    end
    
    context "GET" do
      
      setup do
        get :index, :product_id => 123
      end
      
      before_should "find the product" do
        Product.expects(:find).with('123').returns @product
      end
      
      before_should "get the product's photos" do
        @product.expects(:photos).returns @photos
      end
      
      should assign_to(:product).with {@product}
      should assign_to(:photos).with {@photos}
      
      should render_template(:index)
      
    end
    
  end
  
  context "destroy" do
    
    setup do
      stub_access
      @photo = Factory.build(:product_photo)
      @photo.stubs(:product_id).returns 123
      ProductPhoto.stubs(:find).returns @photo
    end
    
    context "DELETE" do
      
      setup do
        delete :destroy, :id => 123
      end

      before_should "find the photo" do
        ProductPhoto.expects(:find).with('123').returns @photo
      end

      before_should "destroy the photo" do
        @photo.expects(:destroy).returns true
      end

      should respond_with(:redirect)
      
    end
    
  end
end