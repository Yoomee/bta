require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class TopicsControllerTest < ActionController::TestCase
  
  context "class on call to allowed_to?" do
  
    setup do
      @member = Factory.build(:member)
      @forum = Factory.build(:forum)
      @topic = Factory.build(:topic, :forum => @forum, :id => 123)
      Topic.stubs(:find).with(123).returns @topic
    end
    
    should 'return true with show if logged in' do
      assert TopicsController.allowed_to?({:action => 'show', :id => @topic.id}, @member)
    end
    
    should 'return true with show if viewable_by? is true' do
      @forum.expects(:viewable_by?).with(@member).returns(true)
      assert TopicsController.allowed_to?({:action => 'show', :id => @topic.id}, @member)
    end
    
    should 'return false with show if viewable_by? is false' do
      @forum.expects(:viewable_by?).with(@member).returns(false)
      assert !TopicsController.allowed_to?({:action => 'show', :id => @topic.id}, @member)
    end
  
    should 'return true with show if is_admin' do
      @member.is_admin = true
      assert TopicsController.allowed_to?({:action => 'show', :id => @topic.id}, @member)
    end
    
  end
  
end