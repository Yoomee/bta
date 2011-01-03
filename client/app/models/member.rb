Member.class_eval do
  
  has_wall
  
  class << self
    
    def nic
      Member.find(9)
    end
    
  end
  
end