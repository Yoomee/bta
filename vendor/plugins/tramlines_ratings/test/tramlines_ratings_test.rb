require File.dirname(__FILE__) + '/../../../../test/test_helper'

class TramlinesRatingsTest < ActiveSupport::TestCase

  context "ActiveRecord::Base" do
    
    should "have a rateable_by_member class method" do
      assert_respond_to ActiveRecord::Base, :rateable_by_member
    end
    
    should "have a is_rateable? instance method" do
      Status.rateable_by_member
      assert_respond_to Status.new, :is_rateable?
    end
    
  end

  context "using named_scope top_rated" do
    
    setup do
      Page.rateable_by_member
      @member1 = Factory.create(:member)
      @member2 = Factory.create(:member)
      @page1 = Factory.create(:page, :id => 1)
      @page2 = Factory.create(:page, :id => 2)
      @page3 = Factory.create(:page, :id => 3)
      @page4 = Factory.create(:page, :id => 4)      
      
      @page1.add_rating_for!(@member1, 1)
      @page1.add_rating_for!(@member2, 1)

      @page2.add_rating_for!(@member1, 2)
      @page2.add_rating_for!(@member2, -1)

      @page4.add_rating_for!(@member1, -1)
      @page4.add_rating_for!(@member2, -1)
      
    end
    
    should "return records in order of highest average rating" do
      assert_equal Page.top_rated.collect(&:id), [1,2,3,4]
    end
    
  end

end
