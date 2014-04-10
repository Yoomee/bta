require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ForumsControllerTest < ActionController::TestCase
  
  context "class on call to allowed_to?" do
  
    setup do
      @member = Factory.build(:member)
      @forum = Factory.build(:forum, :id => 123)
      Forum.stubs(:find).with(123).returns @forum
    end
    
    should 'return true with show if logged in' do
      assert ForumsController.allowed_to?({:action => 'show', :id => @forum.id}, @member)
    end
    
    should 'return true with show if viewable_by? is true' do
      @forum.expects(:viewable_by?).with(@member).returns(true)
      assert ForumsController.allowed_to?({:action => 'show', :id => @forum.id}, @member)
    end
    
    should 'return false with show if viewable_by? is false' do
      @forum.expects(:viewable_by?).with(@member).returns(false)
      assert !ForumsController.allowed_to?({:action => 'show', :id => @forum.id}, @member)
    end
  
    should 'return true with show if is_admin' do
      @member.is_admin = true
      assert ForumsController.allowed_to?({:action => 'show', :id => @forum.id}, @member)
    end
    
  end  
  
end