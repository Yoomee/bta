class ForumRankingsController < ApplicationController

  admin_only :create, :destroy, :edit, :index, :new, :show, :update

  before_filter :get_forum_ranking, :only => [:destroy, :edit, :show, :update]

  def create
    @forum_ranking = ForumRanking.new(params[:forum_ranking])
    if @forum_ranking.save
      flash[:notice] = "Successfully created forum ranking."
      redirect_to forum_rankings_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @forum_ranking.destroy
    flash[:notice] = "Successfully deleted forum ranking."
    redirect_to_waypoint_after_destroy
  end

  def edit

  end
  
  def index
    @manual_forum_rankings = ForumRanking.num_posts_needed_null.ascend_by_name
    @automatic_forum_rankings = ForumRanking.num_posts_needed_not_null.ascend_by_num_posts_needed
  end  
  
  def new
    @forum_ranking = ForumRanking.new
  end

  def show

  end

  def update
    if @forum_ranking.update_attributes(params[:forum_ranking])
      flash[:notice] = "Successfully updated forum ranking."
      redirect_to @forum_ranking
    else
      render :action => 'edit'
    end
  end
  
  private
  def get_forum_ranking
    @forum_ranking = ForumRanking.find(params[:id])
  end

end