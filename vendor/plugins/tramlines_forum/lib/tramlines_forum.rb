module TramlinesForum
  def self.included(klass)
    Member.send(:include, TramlinesForum::MemberExtensions)
    Notifier.send(:include, TramlinesForum::NotifierExtensions)
  end
end
