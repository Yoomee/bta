require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class ForumRankingTest < ActiveSupport::TestCase

  subject {Factory.create(:forum_ranking)}
  
  should have_db_column(:name).of_type(:string)
  should have_db_column(:num_posts_needed).of_type(:integer)
  
  should have_many(:members)
  
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  
end