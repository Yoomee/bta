ApplicationController.class_eval do

  ExceptionNotifier.email_prefix = 'BTA: '
  ExceptionNotifier.exception_recipients = 'developers@yoomee.com'

  skip_before_filter :force_password_change

end
