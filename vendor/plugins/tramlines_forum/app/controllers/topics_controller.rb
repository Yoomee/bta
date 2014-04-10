class TopicsController < ApplicationController

  BAN_ACTIONS = %w{show create edit new update}

  include TramlinesForum::Banning
    
  admin_only :destroy
  member_only :create, :new
  owner_only :edit, :update
  
  custom_permission(:show) do |url_options, member|
    if member.try(:is_admin?)
      true
    else
      topic = Topic.find(url_options[:id])
      topic.forum ? topic.forum.viewable_by?(member) : true
    end
  end
  
  before_filter :get_forum, :only => %w{new}
  before_filter :get_topic, :only => %w{edit destroy show update}
  
  def create
    @topic = Topic.new(params[:topic])
    @topic.viewed_by @m
    if @topic.save
      flash[:notice] = "Topic Saved Successfully"
      redirect_to @topic.forum
    else
      render :action => 'new'
    end
  end
  
  #Action to delete a topic or sticky
  def destroy
    if @topic.destroy
      flash[:notice] = "Topic deleted"
      redirect_to @topic.forum
    else
      flash[:notice] = "Unable to delete Topic"
      redirect_to @topic.forum
    end
  end
  
  #Action to edit a topic or sticky
  def edit
    @post = @topic.posts.first
    @page_title = "Edit Topic"
  end
 
  #Action to allow a user to create a new topic
  def new
    @topic = @forum.topics.build(:member => @logged_in_member)
    @topic.posts.build(:member => @logged_in_member)
  end
  
  #Action to set up an RSS Feed
  def rss
    @topic = Topic.find params[:id]
    @description = Setting.get_value :system, :slogan
    @language = Setting.get_value :system, :language
    @link = Setting.get_value :system, :site_url
    @title = "#{Setting.get_value :system, :site_name} - forums - #{@topic.subject}"
    render :layout => false
  end

  #Action to show a topic and all its posts
  def show
    @posts = @topic.posts.paginate(:page => params[:page])
    @topic.viewed_by @m
    @topic.increment 'views'
    Topic.record_timestamps = false
    @topic.save
    Topic.record_timestamps = true
    @member = @m || ""
    @page_title = @topic.preview_subject
  end
  
  #Action to update a topic of Sticky
  def update
    if @topic.update_attributes params[:topic]
      flash[:notice] = "Topic Updated Successfully"
      redirect_to @topic.forum
    else
      render :action => 'edit'
    end
  end
  
  private
  def get_forum
    @forum = Forum.find(params[:forum_id])
  end
  
  def get_topic
    @topic = Topic.find(params[:id])
  end
  
end
  
