require File.dirname(__FILE__) + '/../../../test/test_helper'
class CartTest < ActiveSupport::TestCase
  
  should have_db_column(:bta_member).of_type(:boolean).with_options(:default => false)
  should have_db_column(:overseas).of_type(:boolean).with_options(:default => false)
  
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
    
    should "reset overseas when bta_member is set to true and saved" do
      @cart.bta_member = true
      @cart.save!
      assert !@cart.overseas?
    end      
    
    should "set bta_member when bta_member is set to true" do
      @cart.bta_member = true
      assert @cart.bta_member?
    end
    
  end
  
end
