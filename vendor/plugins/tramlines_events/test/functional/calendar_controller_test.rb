require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class CalendarControllerTest < ActionController::TestCase
  
  context "index" do
    
    context "GET with invalid date" do
      
      setup do
        stub_access
        get :index, :year => 'day', :month => 0
      end
      
      should respond_with(:not_found)
      
    end
    
  end  
  
end