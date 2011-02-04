require File.dirname(__FILE__) + '/../../../test/test_helper'
class CartTest < ActiveSupport::TestCase
  
  should have_db_column(:bta_member).of_type(:boolean).with_options(:default => false)
  should have_db_column(:donation_amount_in_pence).of_type(:integer).with_options(:default => 0)
  should have_db_column(:donation_gift_aid).of_type(:boolean).with_options(:default => false)
  should have_db_column(:overseas).of_type(:boolean).with_options(:default => false)

  context "an instance" do
    
    setup do
      @cart = Factory.build(:cart)
    end
    
    should "return the donation amount in pounds as a string on call to donation_amount_in_pounds_s" do
      @cart.donation_amount_in_pence = 1200
      assert_equal "12.00", @cart.donation_amount_in_pounds_s
    end
    
    should "return the donation amount in pounds on call to donation_amount_in_pounds" do
      @cart.donation_amount_in_pence = 1234
      assert_equal 12.34, @cart.donation_amount_in_pounds
    end
    
    should "update the donation_amount_in_pence on call to donation_amount_in_pounds=" do
      @cart.donation_amount_in_pounds = 56.78
      assert_equal 5678, @cart.donation_amount_in_pence
    end
    
    should "update the donation_amount_in_pence on call to donation_amount_in_pounds_s=" do
      @cart.donation_amount_in_pounds_s = "90.12"
      assert_equal 9012, @cart.donation_amount_in_pence
    end

  end
  
  context "an instance with a non-gift-aid donation" do
    
    setup do
      product = Factory.build(:product, :name => 'Test product', :price_in_pence => 5678)
      @item = Factory.build(:cart_item, :product => product, :quantity => 1, :bta_member => false, :overseas => false)
      @cart = Factory.build(:cart, :donation_amount_in_pence => 1234, :donation_gift_aid => false, :items => [@item])
    end
    
    should "include the donation amount on call to paypal_url" do
      assert_match(/amount_2=12.34/, @cart.paypal_url)
    end
    
    should "include the donation quantity on call to paypal_url" do
      assert_match(/quantity_2=1/, @cart.paypal_url)
    end
    
    should "include the non-gift-aid donation details to paypal on call to paypal_url" do
      assert_match(/item_name_2=Non-gift-aid donation/, @cart.paypal_url)
    end
    
    should "not contain the temporary donation item after calling paypal_url" do
      assert_equal [@item], @cart.items
    end
    
    should "return true to has_donation?" do
      assert @cart.has_donation?
    end
    
  end
  
  context "an instance with bta_member set to true" do
    
    setup do
      @cart = Factory.build(:cart, :bta_member => true)
    end
    
    should "have bta_member true" do
      assert @cart.bta_member?
    end
    
    should "reset bta_member when overseas is set to true and saved" do
      @cart.overseas = true
      @cart.save!
      assert !@cart.bta_member?
    end
    
    should "set overseas when overseas is set to true" do
      @cart.overseas = true
      assert @cart.overseas?
    end
    
  end
  
  context "an instance with overseas set to true" do
    
    setup do
      @cart = Factory.build(:cart, :overseas => true)
    end
    
    should "have overseas true" do
      assert @cart.overseas?
    end
    
    should "set bta_member when bta_member is set to true" do
      @cart.bta_member = true
      assert @cart.bta_member?
    end
    
  end

  context "an instance with a gift-aid donation" do
    
    setup do
      product = Factory.build(:product, :name => 'Test product', :price_in_pence => 5678)
      @item = Factory.build(:cart_item, :product => product, :quantity => 1, :bta_member => false, :overseas => false)
      @cart = Factory.build(:cart, :donation_amount_in_pence => 1234, :donation_gift_aid => true, :items => [@item])
    end
    
    should "include the donation amount on call to paypal_url" do
      assert_match(/amount_2=12.34/, @cart.paypal_url)
    end
    
    should "include the donation quantity on call to paypal_url" do
      assert_match(/quantity_2=1/, @cart.paypal_url)
    end

    should "include the gift-aid donation details on call to paypal_url" do
      assert_match(/item_name_2=Gift-aid donation/, @cart.paypal_url)
    end
    
    should "not contain the temporary donation item after calling paypal_url" do
      assert_equal [@item], @cart.items
    end
    
    should "return true to has_donation?" do
      assert @cart.has_donation?
    end
    
  end
  
  context "an instance without a donation" do
    
    setup do
      @cart = Factory.build(:cart, :donation_amount_in_pence => 0, :donation_gift_aid => false)
    end
    
    should "not return a donation item in the URL on call to paypal_url" do
      assert_no_match(/donation/, @cart.paypal_url)
    end
    
    should "return false to has_donation?" do
      assert !@cart.has_donation?
    end
    
  end
  
end
