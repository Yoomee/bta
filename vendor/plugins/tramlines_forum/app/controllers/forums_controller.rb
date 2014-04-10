class ForumsController < ApplicationController

  # # Handled my forum permissions.
  # FORUM_READ_ACTIONS = %w{no_posts_yet rss show}
  # INSUFFICIENT_PERMISSION_MESSAGE  = 'You need to be a logged in to use the forum. If you have previously registered login now, otherwise please complete the brief details to register.'
  #  
  # before_filter :anon_last_visit_time
  # 
  # has_admin_action :manage
  # has_check_ownership_actions %w{delete edit update}
  # has_read_actions FORUM_READ_ACTIONS + %w{index list show}
  # has_write_actions %w{create delete edit update new}
  
  admin_only :create, :destroy, :edit, :new, :update
  custom_permission(:show) do |url_options, member|
    if member.try(:is_admin?)
      true
    else
      forum = Forum.find(url_options[:id])
      forum.viewable_by?(member)
    end
  end

  before_filter :get_forum, :only => %w{edit destroy update show}

  #Action to create a new forum
  def create
    @forum = Forum.new params[:forum]
    if @forum.save
      flash[:notice] = 'Forum was successfully created.'
      redirect_to @forum
    else
      @breadcrumb = [['Forum Categories', {:controller => 'forum', :action => 'index'}], ['New Forum']]
      render :action => 'new'
    end
  end
 
  #Action to delete a forum
  def destroy
    if @forum.destroy
      flash[:notice] = "Forum Deleted"
      redirect_to forums_path
    else
      flash[:error] = "Failed to Delete Forum"
      redirect_to forums_path
    end
  end
  
  def edit
    @breadcrumb = @forum.breadcrumb + ['Edit']
  end

  def index
    if logged_in?
      @forums = admin_logged_in? ? Forum.all : Forum.viewable_by(logged_in_member)
    else
      @forums = Forum.not_is_private
    end
    @breadcrumb = [['Forums']]
  end
 
  def manage
    @forum_pages, @forum_categories = Forumcategory.paginate :per_page => 10, :order => 'title asc'
    @breadcrumb = [['Manage Forums']]
    @page_title = 'Manage Forums'
  end
  
  #Action to allow the user to create a new forum
  def new
    @forum = Forum.new
    @breadcrumb = [['Forums', {:controller => 'forum', :action => 'index'}], ['New Forum']]
  end
  
  #Action to set up an RSS Feed
  def rss
    begin
      @forum = Forum.find params[:id]
      @description = Setting.get_value :system, :slogan
      @language = Setting.get_value :system, :language
      @link = Setting.get_value :system, :site_url
      @title = "#{Setting.get_value :system, :site_name} - forums - #{@forum.title}"
      @items = @forum.find_all_items
      render :layout => false
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
  
  #Action to show a forum and all the topics and posts
  def show
    @forum = Forum.find params[:id]
    @topics = @forum.topics.recently_posted_to_with_stickies_first.paginate(:page => params[:page])
    @member = @m || ""
  end
  
  def update
    if @forum.update_attributes params[:forum]
      flash[:notice] = "Forum successfully updated"
      redirect_to @forum
    else
      @breadcrumb = @forum.breadcrumb + ['Edit']
      render :action => 'edit'
    end
  end
  
  private
  def get_forum
    @forum = Forum.find(params[:id])
  end

end

