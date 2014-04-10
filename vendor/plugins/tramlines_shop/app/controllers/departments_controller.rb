class DepartmentsController < ApplicationController

  admin_only :create, :destroy, :edit, :new, :update, :map

  before_filter :get_department, :only => %w{destroy edit show update}

  def create
    @department = Department.new(params[:department])
    if @department.save
      flash[:notice] = 'Department successfully created'
      redirect_to_waypoint
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def show
  end

  def index
    if Department.active.count == 1
      redirect_to :action => "show", :id => Department.active.first
    else
      @departments = Department.roots.active
    end
  end
  
  def map
    if admin_logged_in?
      @departments = Department.roots.not_deleted
    else
      @departments = Department.roots.active
    end
    set_waypoint
  end
  
  def destroy
    @department.destroy
    flash[:notice] = 'Department successfully deleted.'
    redirect_to_waypoint
  end
  
  # Action to allow a user to create a new department
  def new
    @department = Department.new(:parent_id => params[:department_id])
  end
  
  # Action to update the changes in a department
  def update
    if @department.update_attributes(params[:department])
      flash[:notice] = 'Department was successfully updated.'
      redirect_to_waypoint
    else
      render :action => 'edit'
    end
  end
  
  private
  def get_department
    @department = Department.find(params[:id])
  end
  
  
  
  
  ##################
  


=begin

  # Action to allow the user an opportunity to make a new subdepartment
  def addsub
      @department = Department.new
      @parent = Department.find params[:id]
      @page_title = 'Add subdepartment'
      @breadcrumb = @parent.breadcrumb << [@page_title]
  end

  # Action to create a new product given POST data
  def createproduct
    @product = Product.new params[:product]
    @product.member = @m
    @product.status = 'ACTIVE'
    if @product.save
      flash[:notice] = 'Product successfully created'
      redirect_to :controller => 'product', :action => 'show', :id => @product
    else
      @page_title = 'Add product'
      @breadcrumb = @product.department.breadcrumb << [@page_title]
      @department_options = Department.get_department_options @m
      render :action => 'addproduct'
    end
  end

  # Action to create a new subsection given POST data
  def createsub
    @parent = Department.find params[:id]
    @department = Department.new params[:department]
    @department.parent = @parent
    @department.member = @m
    @department.status = 'ACTIVE'
    if @department.save
      flash[:notice] = 'Subsection successsfully created.'
      redirect_to_waypoint
    else
      @page_title = 'Add subdepartment'
      @breadcrumb = @parent.breadcrumb << [@page_title]
      render :action => 'addsub'
    end
  end


  # # Action to allow a user to view a department
  # def show
  #   @department = Department.find params[:id]
  #   if @department.viewable_by_member? @m
  #     if @department.number_of_active_products == 1
  #       redirect_to :controller => 'product', :action => 'show', :id => @department.products.first
  #     end
  #     @products = @department.purchasable_products_paginated @m, :per_page => Setting.get_value(:shop, :products_per_page), :page => params[:page]
  #     @page_title = @department.name
  #     @breadcrumb = @department.breadcrumb_without_link
  #   else
  #     redirect_to :controller => 'shop', :action => 'not_permitted'
  #   end
  # end
=end
end
