class ContactCategory < ActiveRecord::Base
  
  has_many :contacts, :foreign_key => "category_id"
  validates_presence_of :name
  
  class << self
    
    def select_options
      [["None",'']] + all.collect {|c| [c.name, c.id]}
    end
    
  end
  
  def to_s
    name
  end
  
end
