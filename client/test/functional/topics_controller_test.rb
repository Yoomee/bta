require File.dirname(__FILE__) + '/../../../test/test_helper'
class TopicsControllerTest < ActionController::TestCase
  
  context "on call to allowed_to? with show" do
  
    setup do
      @member = Factory.build(:member)
      @topic = Factory.build(:topic, :id => 123)
      Topic.stubs(:find).with(123).returns @topic
    end

    should 'return false if logged out' do
      assert !TopicsController.allowed_to?({:action => 'show', :id => @topic.id}, nil)
    end
    
  end
  
end