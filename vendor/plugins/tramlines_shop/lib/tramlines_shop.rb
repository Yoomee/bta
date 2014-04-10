module TramlinesShop
  
  def self.included(klass)
    Member.send(:include, TramlinesShop::MemberExtensions)
    Notifier.send(:include, TramlinesShop::NotifierExtensions)
    ApplicationController.send(:include, TramlinesShop::ApplicationControllerExtensions)
    require "#{RAILS_ROOT}/vendor/plugins/tramlines_shop/app/models/order"
  end
  
end