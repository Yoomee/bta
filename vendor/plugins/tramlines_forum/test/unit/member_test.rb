require File.dirname(__FILE__) + '/../../../../../test/test_helper'
class MemberTest < ActiveSupport::TestCase
  
  should have_db_column(:banned_from_forum).of_type(:boolean)
  should have_db_column(:forum_ranking_id).of_type(:integer)
  
  should belong_to(:forum_ranking)
  should have_and_belong_to_many(:forums)
  
  context "on call to forum_ranking_name" do
    
    setup do
      @member = Factory.build(:member)
      @manual_ranking = Factory.create(:forum_ranking, :id => 1)
      @auto_ranking_1 = Factory.create(:forum_ranking, :num_posts_needed => 10, :id => 2)
      @auto_ranking_2 = Factory.create(:forum_ranking, :num_posts_needed => 0, :id => 3)
      @member.posts.stubs(:count).returns(5)
    end
    
    should "return specific ranking if forum_ranking_id is not nil" do
      @member.forum_ranking_id = 1
      assert_equal @manual_ranking.name, @member.forum_ranking_name
    end
    
    should "return ranking based on number of posts if forum_ranking_id is nil" do
      assert_equal @auto_ranking_2.name, @member.forum_ranking_name
    end
    
    should "return correct ranking based on number of posts if forum_ranking_id is nil" do
      @member.posts.stubs(:count).returns(10)
      assert_equal @auto_ranking_1.name, @member.forum_ranking_name
    end
    
  end
  
end