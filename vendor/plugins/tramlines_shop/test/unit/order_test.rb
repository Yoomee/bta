require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class OrderTest < ActiveSupport::TestCase
  
  should have_db_column(:email).of_type(:string)
  should validate_presence_of(:email)
  
  should have_db_column(:forename)
  should validate_presence_of(:forename)
  
  should have_db_column(:surname)
  should validate_presence_of(:surname)

  should have_db_column(:transaction_reference).of_type(:string)
  should have_db_column(:hashed_reference).of_type(:string)

  should have_db_column(:created_at).of_type(:datetime)
  should have_db_column(:updated_at).of_type(:datetime)
  
  should have_db_column(:dispatched_at).of_type(:datetime).with_options(:default => nil)
  should have_db_column(:cancelled_at).of_type(:datetime).with_options(:default => nil)
  
  should have_db_column(:aasm_state).of_type(:string)

  should have_many(:lines)
  
  
end