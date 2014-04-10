class PostsController < ApplicationController

  BAN_ACTIONS = %w{show create destroy edit new update}

  include TramlinesForum::Banning
  
  before_filter :get_post, :only => %w{show edit destroy update}
  before_filter :get_topic, :only => %w{new}
  
  member_only :create, :new
  owner_only :edit, :update, :destroy

  class << self
    
    def allowed_to_with_posts?(url_options, member)
      returning out = allowed_to_without_posts?(url_options, member) do
        if url_options[:action].to_s == 'destroy'
          post = Post.find(url_options[:id])
          return false if post == post.topic.posts.first
        end
      end      
    end
    alias_method_chain :allowed_to?, :posts
    
  end

  def create
    @post = Post.new params[:post]
    @post.viewed @logged_in_member
    if @post.save
      @post.topic.increment 'replies'
      @post.topic.save
      @post.topic.notify_others @post
      flash[:notice] = "Post Submitted Successfully"
      redirect_to @post.topic
    else
      @page_title = "Post Reply"
      render :action => 'new'
    end
  end
  
  def destroy
    @topic = @post.topic
    if @topic.posts.count > 1
      if @post.destroy
        flash[:notice] = "Post Deleted"
        redirect_to forum_topic_path(:forum_id => @topic.forum, :id => @topic)
      end
    else
      redirect_to @topic, :method => :delete
    end
  end
  
  def edit
  end
  
  def new
    @post = @topic.posts.build(:member => @logged_in_member, :subject => @topic.get_last_post_subject)
  end
  
  def show
    redirect_to :controller=>'topics', :action=>'show', :id=> @post.topic_id, :anchor=> @post.id, :page => @post.page_num
  end

  def update
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post Updated Successfully"
      redirect_to @post.topic
    else
      render :action => "edit"
    end
  end

  # def download
  #   begin
  #     @post = Post.find params[:id]
  #     if File.exists?("public/uploads/posts/#{@post.file}")
  #       send_file("public/uploads/posts/#{@post.file}")
  #     else
  #       flash[:notice] = "Cannot find file to download"
  #       redirect_to :controller=>'topic', :action=>'show', :id=>@post.topic.id, :anchor=>@post.id
  #     end
  #   rescue ActiveRecord::RecordNotFound
  #     flash[:notice] = "The post cannot be found"
  #     redirect_to :controller => 'forum', :action => 'index'    
  #   end
  # end
  
  private
  def get_post
    @post = Post.find(params[:id])
  end

  def get_topic
    @topic = Topic.find(params[:topic_id])
  end
  
end
