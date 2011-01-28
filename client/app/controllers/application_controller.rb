ApplicationController.class_eval do

  ExceptionNotifier.email_prefix = 'BTA: '

  skip_before_filter :force_password_change

end
