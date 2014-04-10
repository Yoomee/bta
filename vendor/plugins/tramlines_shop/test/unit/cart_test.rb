require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class CartTest < ActiveSupport::TestCase
  
  should belong_to(:member)
  should have_many(:items).dependent(:destroy)
  
  context "an instance" do
    
    setup do
      @cart = Factory.build(:cart)
      # fix for tchc shop
      @cart.stubs(:postage_in_pounds).returns 0.0
    end
    
    should "return false to contains_item? when the item doesn't belong to the cart" do
      item = Factory.build(:cart_item)
      @cart.expects(:items).returns [Factory.build(:cart_item), Factory.build(:cart_item)]
      assert !@cart.contains_item?(item)
    end
      
    should 'return false to empty? if it has a non-empty item' do
      @cart.expects(:items).returns [mock(:empty? => true), mock(:empty? => false)]
      assert !@cart.empty?
    end
    
    should "return the total of the cart's items' prices on call to total_in_pounds" do
      @cart.expects(:items).returns [mock(:price_in_pounds => 12.34), mock(:price_in_pounds => 56.78)]
      assert_equal 69.12, @cart.total_in_pounds
    end

    should 'return true to contains_item? when the item belongs to the cart' do
      item = Factory.build(:cart_item)
      @cart.expects(:items).returns [item, Factory.build(:cart_item)]
      assert @cart.contains_item?(item)
    end
    
    should 'return true to empty? if it has no items' do
      @cart.expects(:items).returns []
      assert @cart.empty?
    end
    
    # Hypothetical, but just in case
    should 'return true to empty? if it only has empty items' do
      @cart.expects(:items).returns [mock(:empty? => true), mock(:empty? => true)]
      assert @cart.empty?
    end

  end
  
end
