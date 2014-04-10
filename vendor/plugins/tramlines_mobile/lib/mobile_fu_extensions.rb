module MobileFuExtensions
  def self.included(klass)
    klass.alias_method_chain :is_mobile_device?, :tramlines_mobile
  end
  
  def is_mobile_device_with_tramlines_mobile?
    is_mobile_device_without_tramlines_mobile? && !is_device?('ipad')
  end
  
end
