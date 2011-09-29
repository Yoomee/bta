#run "cd #{current_path} && rake ts:rebuild RAILS_ENV=production -t"
run "cd #{current_path} && whenever --update-crontab #{current_path}"