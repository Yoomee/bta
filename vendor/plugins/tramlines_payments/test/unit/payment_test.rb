require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class PaymentTest < ActiveSupport::TestCase

  subject {Factory.create(:payment)}
  
  should have_db_column(:attachable_id)
  should have_db_column(:attachable_type)
  should have_db_column(:reference)
  should have_db_column(:payment_pence)
  should have_db_column(:uk_taxpayer).of_type(:boolean)
  
  should belong_to(:attachable)
  
  should validate_presence_of(:attachable)
  should validate_presence_of(:payment_pence)
  should validate_presence_of(:reference)
  should validate_presence_of(:uk_taxpayer)
  should validate_uniqueness_of(:reference)
  
end