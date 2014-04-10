require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ForumTest < ActiveSupport::TestCase

  subject {Factory.create(:forum)}
  
  should have_db_column(:title).of_type(:string)
  should have_db_column(:description).of_type(:text)
  should have_db_column(:allow_uploads).of_type(:integer)
  should have_timestamps
  should have_db_column(:is_private).of_type(:boolean)
  
  should have_many(:topics)
  should have_many(:posts)
  should have_and_belong_to_many(:members)
  
  should validate_presence_of(:title)
  should validate_uniqueness_of(:title)
  
  context "on call to named_scope viewable_by" do
    
    setup do
      @member = Factory.create(:member)      
      @normal_forum = Factory.create(:forum, :is_private => false, :id => 1)
      @private_forum = Factory.create(:forum, :is_private => true, :id => 2)
    end
    
    should "return all forums member can view" do
      assert_equal [1], Forum.viewable_by(@member).collect(&:id)
    end
    
    should "not return private forums member cannot view" do
      @private_forum.members << @member
      assert_equal [1, 2], Forum.viewable_by(@member).collect(&:id)
    end
    
  end
  
  context "on call to viewable_by?" do
    
    setup do
      @forum = Factory.build(:forum)
      @member = Factory.build(:member)
    end
    
    should "return true if not private" do
      assert @forum.viewable_by?(@member)
    end
    
    should "return true if not private and member is_admin" do
      @member.is_admin = true
      assert @forum.viewable_by?(@member)
    end
    
    should "return false if private" do
      @forum.is_private = true
      assert !@forum.viewable_by?(@member)
    end
    
    should "return true if private and member is_admin" do
      @forum.is_private = true
      @member.is_admin = true
      assert @forum.viewable_by?(@member)
    end

    should "return true if private and member allowed to view forum" do
      @forum.update_attribute(:is_private, true)
      @member.save
      @forum.members << @member
      assert @forum.viewable_by?(@member)
    end
    
  end
  
end