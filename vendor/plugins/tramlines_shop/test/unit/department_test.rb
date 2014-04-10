require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class DepartmentTest < ActiveSupport::TestCase
  
  should have_db_column(:created_at).of_type(:datetime)
  should have_db_column(:deleted_at).of_type(:datetime)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:intro).of_type(:text)
  should have_db_column(:name).of_type(:string)
  should have_db_column(:updated_at).of_type(:datetime)
  should have_db_column(:weight).of_type(:integer).with_options(:default => 0)

  should have_many(:products).dependent(:destroy)
  
  should validate_presence_of(:name)
  
  context "a saved instance" do
    
    setup do
      @department = Factory.create(:department)
      @time_now = Time.now
      Time.stubs(:now).returns @time_now
    end
    
    context "on call to destroy" do
      
      setup do
        @result = @department.destroy
      end
    
      before_should "save the department" do
        @department.expects(:update_attribute).with(:deleted_at, @time_now).returns true
      end
    
      should "have the deleted_at set" do
        assert_equal @time_now, @department.deleted_at
      end
   
      should "return true" do
        assert @result
      end
    
      should "still exist" do
        assert Department.exists?(@department.id)
      end
    
    end
    
  end
  
  context "a valid instance" do
    
    setup do
      @department = Factory.build(:department)
    end
    
    should "save" do
      assert @department.save
    end
    
  end

  context "class" do
    
    should "not return a deleted department on call to active" do
      department = Factory.create(:deleted_department)
      assert_does_not_contain Department.active, department
    end
    
    should "return an active department on call to active" do
      department = Factory.create(:department)
      assert_contains Department.active, department
    end

  end
  
end

