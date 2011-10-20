namespace :bta do
  
  desc "Send a notification to Nic of a new post"
  task :notify_nic => :environment do
    Tramlines::load_plugins
    post = Post.find(ENV['POST_ID'])
    member_nic = Member.nic
    if member_nic && !post.owned_by?(member_nic) && !post.topic.posts.exists?(:member_id => member_nic.id, :email => true)
      Notifier.deliver_post_notification(member_nic, post)
    end
  end
  
end