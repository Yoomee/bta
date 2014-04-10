class Rating < ActiveRecord::Base
  
  belongs_to :member
  belongs_to :rateable, :polymorphic => true
  
  named_scope :for_member, lambda {|member| {:conditions => {:member_id => member.id}}}
  
  validates_uniqueness_of :member_id, :scope => [:rateable_id, :rateable_type]
  validates_presence_of :rateable
  
  def positive?
    score > 0
  end
  
  def negative?
    score < 0
  end
  
end