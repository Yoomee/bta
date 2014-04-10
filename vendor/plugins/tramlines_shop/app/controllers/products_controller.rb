class ProductsController < ApplicationController

  admin_only :create, :destroy, :edit, :new, :update

  before_filter :get_product, :only => %w{destroy edit show update}

  def create
    @product = Product.new(params[:product])
    if @product.save
      flash[:notice] = 'Product successfully created'
      redirect_to_waypoint
    else
      render :action => 'new'
    end
  end

  def destroy
    @product.destroy
    redirect_to_waypoint
  end
  
  def edit
  end

  def new
    @product = Product.new(:department_id => params[:department_id])
  end
  
  def show
    if !@logged_in_member.try(:is_admin?) && (@product.department.hidden? || @product.deleted?)
      render_404
    end
  end
  
  def update
    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
      redirect_to_waypoint
    else
      render :action => 'edit'
    end
  end  
  
  private
  def get_product
    @product = Product.find(params[:id])
  end

  # 
  # # Action to allow a user to add a product option to a product
  # def add_option
  #     @product = Product.find params[:id]
  #     @page_title = "#{@product.name}: add product option"
  #     @breadcrumb = @product.breadcrumb << ['Add product option']
  #     @option = Option.new
  #     @field_type_options = Option::FIELD_TYPES.collect {|t| [t, t.upcase]}
  # end
  # 
  # # Action to create a new product given POST data
  # def create
  #   @product = Product.new params[:product]
  #   @product.member = @m
  #   @product.status = 'ACTIVE'
  #   if @product.save
  #     flash[:notice] = 'Product successfully created.'
  #     redirect_to :action => 'show', :id => @product
  #   else
  #     @department_options = Department.get_department_options @m
  #     @page_title = 'New product'
  #     @breadcrumb = [['Shop', {:controller => 'shop', :action => 'index'}], [@page_title]]
  #     render :action => 'new'
  #   end
  # end
  # 
  # # Action to create a product option given POST data
  # def create_option
  #     @product = Product.find params[:id]
  #     @option = Option.new params[:option]
  #     @option.product = @product
  #     @option.member = @m
  #     @option.status = 'ACTIVE'
  #     if @option.save
  #       flash[:notice] = 'New option created'
  #       redirect_to_waypoint
  #     else
  #       @page_title = "#{@product.name}: add product option"
  #       @breadcrumb = @product.breadcrumb << ['Add product option']
  #       @field_type_options = Option::FIELD_TYPES.collect {|t| [t, t.upcase]}
  #       render :action => 'add_option'
  #     end
  # end
  # 
  # # Action to delete a product
  # def delete
  #     product = Product.find params[:id]
  #     product.status = 'DELETED'
  #     product.save
  #     flash[:notice] = 'Product successfully deleted.'
  #     redirect_to :controller => 'department', :action => 'show', :id => product.department
  # end
  # 
  # # Action to allow a user to edit a product
  # def edit
  #     @product = Product.find params[:id]
  #     @department_options = Department.get_department_options @m
  #     @page_title = "Edit product: #{@product.name}"
  #     @breadcrumb = @product.breadcrumb << ['Edit']
  # end
  # 
  # def latest
  #   @products = Product.latest_active_and_viewable_by_member @m, Setting.get_value(:shop, :products_per_page), params[:page]
  #   @page_title = 'Latest products'
  #   @breadcrumb = [['Shop', {:controller => 'shop', :action => 'index'}], [@page_title]]
  # end
  # 
  # # Action to allow a user to create a new product
  # def new
  #   @department_options = Department.get_department_options @m
  #   @product = Product.new
  #   @page_title = 'New product'
  #   @breadcrumb = [['Shop', {:controller => 'shop', :action => 'index'}], [@page_title]]
  # end
  # 
  # # Action to display details of a product
  # def show
  #   begin
  #     @product = Product.find params[:id]
  #     if @product.viewable_by_member? @m 
  #       if params[:tag_names].size.nonzero?
  #         @tag_names = params[:tag_names]
  #         tag_names_string = @tag_names.join '/'
  #         @page_title = "#{@product.name}"
  #         @breadcrumb = @product.breadcrumb
  #       else
  #         @page_title = @product.name
  #         @breadcrumb = @product.breadcrumb_without_link
  #       end
  #     else
  #       redirect_to :controller => 'shop', :action => 'not_permitted'
  #     end
  #   rescue ActiveRecord::RecordNotFound
  #     render_404
  #   end
  # end
  # 
  # def special_offers
  #   @products = Product.all_discounted_and_viewable_by_member @m, Setting.get_value(:shop, :products_per_page), params[:page]
  #   @page_title = 'Special offers'
  #   @breadcrumb = [['Shop', {:controller => 'shop'}], ['Special offers']]
  # end
  # 
  # def tag
  #   @tag_names = params[:tag_names]
  #   @tags = @tag_names.map {|tag_name| Tag.find_by_name(tag_name)}.compact.uniq
  #   if @tags.empty?
  #     @products = []
  #     @breadcrumb = [['Shop', {:controller => 'shop', :action => 'index'}], ['Tag not found']]
  #   else
  #     @page_title = @tag_names.map {|tag_name| tag_name.titleize}.join '/'
  #     tagged_products = Product.find_tagged_with_and_viewable_by_member @tag_names, @m 
  #     @products = tagged_products.paginate :per_page => Setting.get_value(:shop, :products_per_page), :page => params[:page]
  #     @breadcrumb = [['Shop', {:controller => 'shop', :action => 'index'}], [@page_title]]
  #   end
  # end
  # 
  # # Action to update a product
  # def update
  #   begin
  #     @product = Product.find params[:id]
  #     if @product.update_attributes params[:product]
  #       flash[:notice] = 'Product was successfully updated.'
  #       redirect_to_waypoint
  #     else
  #       @page_title = "Edit product: #{@product.name}"
  #       @breadcrumb = @product.breadcrumb << ['Edit']
  #       @department_options = Department.get_department_options @m
  #       render :action => 'edit'
  #     end
  #   rescue ActiveRecord::RecordNotFound
  #     render_404
  #   end
  # end
  # 
end
