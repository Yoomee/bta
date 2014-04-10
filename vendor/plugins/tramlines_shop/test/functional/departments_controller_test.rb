require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class DepartmentsControllerTest < ActionController::TestCase
  
  should route(:get, "/departments").to(:action => 'index')

  should have_action(:create).with_level(:admin_only)
  should have_action(:destroy).with_level(:admin_only)
  should have_action(:edit).with_level(:admin_only)
  should have_action(:index).with_level(:open)
  should have_action(:new).with_level(:admin_only)
  should have_action(:show).with_level(:open)
  should have_action(:update).with_level(:admin_only)

  context "create action with invalid attributes" do
    
    setup do
      @department = Factory.build(:department)
      Department.stubs(:new).returns @department
      @department.stubs(:save).returns false
    end
    
    context "POST" do
      
      setup do
        stub_access
        post :create, :department => {:valid_attributes => false}
      end
      
      before_should "initialize the department" do
        Department.expects(:new).with('valid_attributes' => false).returns @department
      end
      
      before_should "attempt to save the department" do
        @department.expects(:save).returns false
      end
      
      should assign_to(:department).with {@department}
      
      should render_template(:new)
      
    end
    
  end

  context "create action with valid attributes" do
    
    setup do
      @department = Factory.build(:department)
      Department.stubs(:new).returns @department
      @department.stubs(:save).returns true
    end
    
    context "POST" do
      
      setup do
        stub_access
        post :create, :department => {:valid_attributes => true}
      end
      
      before_should "initialize the department" do
        Department.expects(:new).with('valid_attributes' => true).returns @department
      end
      
      before_should "save the department" do
        @department.expects(:save).returns true
      end
      
      should respond_with(:redirect)
      
    end
    
  end

  context "destroy action" do
    
    setup do
      @department = Factory.build(:department)
      Department.stubs(:find).returns @department
      @department.stubs(:destroy).returns true
    end
    
    context "DELETE" do
      
      setup do
        stub_access
        delete :destroy, :id => 123
      end
  
      before_should "find the department" do
        Department.expects(:find).with('123').returns @department
      end
      
      before_should "destroy the department" do
        @department.expects(:destroy).returns true
      end

    end

    context "DELETE when the department doesn't have a parent" do
      
      setup do
        stub_access
        @department.stubs(:parent).returns nil
        delete :destroy, :id => 123
      end
            
    end
      
    context "DELETE when the department has a parent" do
      
      setup do
        stub_access
        @parent = Factory.build(:department, :id => 123)
        @department.stubs(:parent).returns @parent
        @department.stubs(:new_record?).returns false
        delete :destroy, :id => 123
      end
        
        
    end
      
  end
  
  context "edit action" do
    
    setup do
      @department = Factory.build(:department, :id => 123)
      Department.stubs(:find).returns @department
      Department.stubs(:roots).returns [Factory.build(:department, :id => 456), Factory.build(:department, :id => 789)]
      Department.any_instance.stubs(:new_record?).returns false
      children_mock = mock
      children_mock.stubs(:inject).returns []
      Department.any_instance.stubs(:children).returns children_mock
    end
    
    context "GET" do
      
      setup do
        stub_access
        get :edit, :id => 123
      end
      
      before_should "find the department" do
        Department.expects(:find).with('123').returns @department
      end
    
      should render_template(:edit)
      
    end
    
  end
  
  context "index action" do
    
    setup do
      @departments = [Factory.build(:department), Factory.build(:department)]
      roots_mock = mock
      roots_mock.stubs(:active).returns @departments
      Department.stubs(:roots).returns roots_mock
      @departments.stubs(:all).returns @departments
    end
    
    context "GET" do
      
      setup do
        get :index
      end
      
      before_should "get the root active departments" do
        Department.expects(:roots).returns mock(:active => @departments)
      end
      
      should assign_to(:departments) {@departments}
      should render_template(:index)
      
    end
    
  end
  
  context "new action" do
    
    setup do
      @department = Factory.build(:department)
      Department.stubs(:new).returns @department
    end
    
    context "GET" do
      
      setup do
        stub_access
        get :new
      end
      
      before_should "initialize the department" do
        Department.expects(:new).returns @department
      end
      
      should assign_to(:department) {@department}
      
      should render_template(:new)
      
    end
    
  end
  
  context "show action" do
    
    setup do
      @department = Factory.build(:department)
      children_mock = mock
      children_mock.stubs(:active).returns [Factory.build(:department), Factory.build(:department)]
      @department.stubs(:children).returns children_mock
      Department.stubs(:find).returns @department
      Department.stubs(:find).with {|*args| args.first == :all}.returns [@department]
      products_mock = mock
      @department.stubs(:products).returns products_mock
      @products = [Factory.build(:product), Factory.build(:product)]
      @products.stubs(:all).returns @products
      products_mock.stubs(:active).returns @products
    end
    
    context "GET" do
      
      setup do
        get :show, :id => 123
      end
      
      before_should "find the department" do
        Department.expects(:find).with('123').returns @department
      end
      
      should render_template(:show)
      
    end
    
  end

  context "update action with invalid attributes" do
    
    setup do
      @department = Factory.build(:department, :id => 123)
      Department.stubs(:find).returns @department
      @department.stubs(:update_attributes).returns false
      @controller.stubs(:department_id_options).returns []
      Department.stubs(:roots).returns [Factory.build(:department, :id => 456), Factory.build(:department, :id => 789)]
      Department.any_instance.stubs(:new_record?).returns false
      children_mock = mock
      children_mock.stubs(:inject).returns []
      Department.any_instance.stubs(:children).returns children_mock
    end
    
    context "PUT" do
      
      setup do
        stub_access
        get :update, :id => 123, :department => {:valid_attributes => false}
      end
      
      before_should "find the department" do
        Department.expects(:find).with('123').returns @department
      end
      
      before_should "update the department" do
        @department.expects(:update_attributes).with('valid_attributes' => false).returns false
      end
      
      should assign_to(:department).with {@department}
      should render_template(:edit)
      
    end
    
  end
  
  context "update action with valid attributes" do
    
    setup do
      @department = Factory.build(:department)
      Department.stubs(:find).returns @department
      @department.stubs(:update_attributes).returns true
    end
    
    context "PUT" do
      
      setup do
        stub_access
        get :update, :id => 123, :department => {:valid_attributes => true}
      end
      
      before_should "find the department" do
        Department.expects(:find).with('123').returns @department
      end
      
      before_should "update the department" do
        @department.expects(:update_attributes).with('valid_attributes' => true).returns true
      end
      
      should assign_to(:department).with {@department}
      should respond_with(:redirect)
      
    end
    
  end
  
end
