class EventCategory < ActiveRecord::Base
  
  has_many :events, :foreign_key => "category_id", :dependent => :nullify
  
  validates_presence_of :name, :color
  
  def to_s
    name
  end
  
end