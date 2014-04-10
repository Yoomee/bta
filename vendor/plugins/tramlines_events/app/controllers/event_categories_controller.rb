class EventCategoriesController < ApplicationController

  admin_only :create, :destroy, :index, :update
  
  def index
    @categories = EventCategory.all(:order => :name)
  end
  
  def create
    @category = EventCategory.new(params[:event_category])
    render :update do |page|
      show_form = false
      if @category.save
        page.insert_html(:after, "#new_category", render("category", :category => @category, :show_form => false))
        page << "$('##{@category.id}_category').effect('highlight', {color:'#E3EBF3'}, 3000);"
        @category = EventCategory.new
      else
        show_form = true
      end
      page["new_category"].replace(render("new_category", :category => @category, :show_form => show_form))
    end
  end
  
  def destroy
    @category = EventCategory.find(params[:id])
    render :update do |page|
      if @category.destroy
        page << "$('##{@category.id}_category').fadeOut('fast', function() {$(this).remove();});"
      end
    end
  end
  
  def update
    @category = EventCategory.find(params[:id])
    render :update do |page|
      if @category.update_attributes(params[:event_category])
        page["#{@category.id}_category"].replace(render("category", :category => @category, :show_form => false))
      else
        page["#{@category.id}_category_form"].replace(render("form", :category => @category, :method => :put, :show_form => true))
        page << "CategoryForm.show_form('#{@category.id}')"
      end
    end
  end

end