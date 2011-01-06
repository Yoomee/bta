require File.dirname(__FILE__) + '/../../../test/test_helper'
class ProductTest < ActiveSupport::TestCase
  
  should have_db_column(:member_price_in_pence).of_type(:integer).with_options(:null => true)
  should have_db_column(:member_special_offer).of_type(:text)
  should have_db_column(:overseas_price_in_pence).of_type(:integer).with_options(:null => true)

  context "an instance" do
    
    setup do
      @product = Factory.build(:product)
    end
    
    should "return nil to member_price_in_pounds if it is blank" do
      @product.member_price_in_pence = nil
      assert_nil @product.member_price_in_pounds
    end
    
    should "return nil to overseas_price_in_pounds if it is blank" do
      @product.overseas_price_in_pence = nil
      assert_nil @product.overseas_price_in_pounds
    end
    
    should "return the price in pounds for members if not blank on call to member_price_in_pounds" do
      @product.member_price_in_pence = 199
      assert_equal 1.99, @product.member_price_in_pounds
    end
    
    should "return the price in pounds for overseas customers if not blank on call to overseas_price_in_pounds" do
      @product.overseas_price_in_pence = 199
      assert_equal 1.99, @product.overseas_price_in_pounds
    end
    
    should "set the member price in pence on call to member_price_in_pounds= when not blank" do
      @product.member_price_in_pounds = 5.42
      assert_equal 542, @product.member_price_in_pence
    end
    
    should "set the member price in pence to nil on call to member_price_in_pounds= when blank" do
      @product.member_price_in_pence = 123
      @product.member_price_in_pounds = ''
      assert_nil @product.member_price_in_pence
    end
    
    should "set the member price in pence to nil on call to member_price_in_pounds= when nil" do
      @product.member_price_in_pence = 123
      @product.member_price_in_pounds = nil
      assert_nil @product.member_price_in_pence
    end
    
    should "set the overseas price in pence on call to overseas_price_in_pounds= when not blank" do
      @product.overseas_price_in_pounds = 5.42
      assert_equal 542, @product.overseas_price_in_pence
    end
    
    should "set the overseas price in pence to nil on call to overseas_price_in_pounds= when blank" do
      @product.overseas_price_in_pence = 123
      @product.overseas_price_in_pounds = ''
      assert_nil @product.overseas_price_in_pence
    end

    should "set the overseas price in pence to nil on call to overseas_price_in_pounds= when nil" do
      @product.overseas_price_in_pence = 123
      @product.overseas_price_in_pounds = nil
      assert_nil @product.overseas_price_in_pence
    end
    
  end

end
