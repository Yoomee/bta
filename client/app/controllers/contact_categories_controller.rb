class ContactCategoriesController < ApplicationController
    
  def index
    @categories = ContactCategory.all(:order => :name)
    render :template => 'categories/index'
  end
  
  def create
    @category = ContactCategory.new(params[:contact_category])
    render :update do |page|
      show_form = false
      if @category.save
        page.insert_html(:after, "#new_category", render("categories/category", :category => @category, :show_form => false))
        page << "$('##{@category.id}_category').effect('highlight', {color:'#E3EBF3'}, 3000);"
        @category = ContactCategory.new
      else
        show_form = true
      end
      page["new_category"].replace(render("categories/new_category", :category => @category, :show_form => show_form))
    end
  end
  
  def destroy
    @category = ContactCategory.find(params[:id])
    render :update do |page|
      if @category.destroy
        page["#{@category.id}_category"].remove
      else
        render :nothing => true
      end
    end
  end
  
  def update
    @category = ContactCategory.find(params[:id])
    render :update do |page|
      if @category.update_attributes(params[:contact_category])
        page["#{@category.id}_category"].replace(render("categories/category", :category => @category, :show_form => false))
      else
        page["#{@category.id}_category_form"].replace(render("categories/form", :category => @category, :method => :put, :show_form => true))
        page << "CategoryForm.show_form('#{@category.id}')"
      end
    end
  end
  
  def show
    @category = ContactCategory.find(params[:id])
    @contacts = @category.contacts.paginate(:page => params[:page], :per_page => 20)
    @title = @category.name
    render :template => 'contacts/index'
  end
end
