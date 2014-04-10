class ProductPhotosController < ApplicationController

  admin_only :create, :destroy, :index, :new
  
  before_filter :get_product, :only => %w{create index new}
  
  def create
    @photo = @product.photos.build(params[:product_photo])
    if @photo.save
      redirect_to product_photos_path(:product_id => @product.id)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @photo = ProductPhoto.find(params[:id])
    @photo.destroy
    redirect_to product_photos_path(:product_id => @photo.product_id)
  end
  
  def new
    @photo = @product.photos.build
  end
  
  def index
    @photos = @product.photos
  end
  
  private
  def get_product
    @product = Product.find(params[:product_id])
  end
  
end