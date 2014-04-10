class RatingsController < ApplicationController

  member_only :create, :destroy

  before_filter :get_rating, :only => [:destroy, :update]

  def create
    if @rating = @logged_in_member.owned_ratings.find(:first, :conditions => {:rateable_type => params[:rating][:rateable_type], :rateable_id => params[:rating][:rateable_id]})
      @rating.attributes = params[:rating]
      @rating.save
    else
      @rating = @logged_in_member.owned_ratings.build(params[:rating].merge(:member_id => @logged_in_member.id))
    end
    update_page
  end
  
  def update
    @rating.attributes = params[:rating]
    update_page
  end
  
  def destroy
    render :update do |page|
      if @rating.destroy
        unique_rating = unique_rating_string(@rating)
        update_like_counts_for(@rating.rateable, page)
        page["#like_list_#{unique_rating}"].replace(render_like_list_for(@rating.rateable))
        new_rating = @rating.rateable.ratings.build(:member => @logged_in_member)
        page["#like_form_#{unique_rating} .like_links"].replace_html(like_link(new_rating))
        page["#like_form_#{unique_rating} form"].replace(render("ratings/form", :rating => new_rating, :polarized => Module.value_to_boolean(params[:polarized])))
      end
    end
  end

  protected
  def get_rating
    @rating = Rating.find(params[:id])
  end

  def update_page
    render :update do |page|
      if @rating.save!
        unique_rating = unique_rating_string(@rating)
        if Module.value_to_boolean(params[:polarized])
          page["#like_form_#{unique_rating} .like_links"].replace_html(like_and_dislike_links(@rating))
        elsif !params[:allow_unlike].blank? && !Module.value_to_boolean(params[:allow_unlike])
          page["#like_form_#{unique_rating} .like_links"].replace_html(like_link(@rating))
        else
          page["#like_form_#{unique_rating} .like_links"].replace_html(unlike_link(@rating))
        end
        page["#like_list_#{unique_rating}"].replace(render_like_list_for(@rating.rateable))        
        update_like_counts_for(@rating.rateable, page)
      end
    end
  end
  
end