ApplicationController.class_eval do

  ExceptionNotifier.email_prefix = 'BTA: '

end
