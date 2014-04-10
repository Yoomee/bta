module TramlinesForum::Banning
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.metaclass.send(:alias_method_chain, :allowed_to?, :forum_banning)
  end
  
  module ClassMethods
    
    def allowed_to_with_forum_banning?(url_options, member)
      allowed_to_without_forum_banning?(url_options, member) && !banned_from_action?(url_options, member)
    end
    
    def banned_from_action?(url_options, member)
      url_options[:action].to_s.in?(self::BAN_ACTIONS) && member.try(:banned_from_forum?)
    end
    
  end
  
end