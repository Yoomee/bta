require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ProductTest < ActiveSupport::TestCase

  should have_db_column(:created_at).of_type(:datetime)
  should have_db_column(:deleted_at).of_type(:datetime)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:name).of_type(:string)
  should have_db_column(:overview).of_type(:text)
  should have_db_column(:price_in_pence).of_type(:integer)
  should have_db_column(:sku).of_type(:string)
  should have_db_column(:updated_at).of_type(:datetime)
  should have_db_column(:weight).of_type(:integer).with_options(:default => 0)  

  should belong_to(:department)
  should have_many(:photos).dependent(:destroy)

  should validate_numericality_of(:price_in_pence)
  should validate_presence_of(:department_id)
  should validate_presence_of(:name)

  context "a deleted product" do
    
    setup do
      @product = Factory.build(:deleted_product)
    end
    
    should "return false to active?" do
      assert !@product.active?
    end
    
    should "return true to deleted?" do
      assert @product.deleted?
    end
  
  end
  
  context "a saved instance" do
    
    setup do
      @product = Factory.create(:product)
      @time_now = Time.now
      Time.stubs(:now).returns @time_now
    end
    
    context "on call to destroy" do
      
      setup do
        @result = @product.destroy
      end
    
      before_should "save the product" do
        @product.expects(:update_attribute).with(:deleted_at, @time_now).returns true
      end
    
      should "return true" do
        assert @result
      end
    
      should "still exist" do
        assert Product.exists?(@product.id)
      end
    
      should "have the deleted_at set" do
        assert_equal @time_now, @product.deleted_at
      end
      
    end
    
  end
  
  context "an active product" do
    
    setup do
      @product = Factory.build(:product)
    end
    
    should "return false to deleted?" do
      assert !@product.deleted?
    end
    
    should "return true to active?" do
      assert @product.active?
    end
    
  end
  
  context "an instance" do
    
    setup do
      @product = Factory.build(:product)
    end
    
    should "return the price in pounds on call to price_in_pounds" do
      @product.price_in_pence = 1234
      assert_equal 12.34, @product.price_in_pounds
    end

    should "update the price_in_pence on call to price_in_pounds" do
      @product.price_in_pounds = 56.78
      assert_equal 5678, @product.price_in_pence
    end
    
  end

  context "class" do
    
    should "not return a deleted product on call to active" do
      product = Factory.create(:deleted_product)
      assert_does_not_contain Product.active, product
    end
    
    should "return an active product on call to active" do
      product = Factory.create(:product)
      assert_contains Product.active, product
    end

  end

end

