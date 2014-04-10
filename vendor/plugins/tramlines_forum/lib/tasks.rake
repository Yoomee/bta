namespace :tramlines_forum do
  
  namespace :topic do
    
    desc "Send a notification about a reply "
    task :notify_others => :environment do
      Tramlines::load_plugins
      post = Post.find(ENV['POST_ID'])
      topic = post.topic
      posts = topic.posts.not_including(post).all(:conditions => {:email => true})
      members = posts.map(&:member).uniq - [post.member]
      puts "#{members.size} members found"
      members.each do |member|
        puts "Sending notification to #{member}"
        Notifier.deliver_post_notification(member, post)
      end
    end
    
  end
  
end