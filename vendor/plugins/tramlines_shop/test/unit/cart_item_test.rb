require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class CartItemTest < ActiveSupport::TestCase
  
  should have_db_column(:quantity).of_type(:integer).with_options(:default => 1)

  should belong_to(:cart)
  should belong_to(:product)

  should validate_presence_of(:cart_id)
  should validate_presence_of(:product_id)
  should validate_presence_of(:quantity)
  
  context "a valid instance" do
    
    setup do
      @cart_item = Factory.build(:cart_item)
    end
    
    should "save" do
      assert @cart_item.save
    end
    
  end

  context "an instance" do
    
    setup do
      @cart_item = Factory.build(:cart_item)
    end
    
    should 'return false to empty if it has quantity greater than 0' do
      @cart_item.quantity = 1
      assert !@cart_item.empty?
    end
    
    should "return the product's price multiplied by the quantity on call to price_in_pounds" do
      @cart_item.expects(:product).returns mock(:price_in_pounds => 3.33)
      @cart_item.expects(:quantity).returns 3
      assert_equal 9.99, @cart_item.price_in_pounds
    end

    should "return true to empty? if its quantity isn't greater than 0" do
      @cart_item.quantity = 0
      assert @cart_item.empty?
    end

  end
  
  context "on call to add_quantity(n)" do
    
    setup do
      @cart_item = Factory.build(:cart_item, :quantity => 3)
    end
    
    should 'add to the quantity when the cart item is not a new record' do
      @cart_item.expects(:new_record?).returns false
      @cart_item.add_quantity(5)
      assert_equal 8, @cart_item.quantity
    end
    
    should "add to the quantity when the cart item is not a new record and n is a string" do
      @cart_item.expects(:new_record?).returns false
      @cart_item.add_quantity('5')
      assert_equal 8, @cart_item.quantity
    end
    
    should 'reset the quantity when the cart item is a new record' do
      @cart_item.expects(:new_record?).returns true
      @cart_item.add_quantity(5)
      assert_equal 5, @cart_item.quantity
    end
    
  end

end
