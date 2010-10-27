class ContactsController < ApplicationController
    
  admin_only :create, :destroy, :index, :new, :show, :update
  
  before_filter :get_contact, :only => %w{show edit update destroy}
  
  def index
    if params[:id] == '#'
      @contacts = Contact.find(:all, :conditions => "name BETWEEN '0%' AND '9%'", :order=>'name').paginate :page => params[:page], :per_page => 50
    else
      params[:id] ||= 'A'
      @contacts = Contact.name_begins_with(params[:id]).ascend_by_name.paginate :page => params[:page], :per_page => 50
    end
    @a_to_z = true
  end
  
  def show
  end
  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:notice] = "Successfully created contact."
      redirect_to @contact
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
      redirect_to @contact
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @contact.destroy
    flash[:notice] = "Successfully deleted contact."
    redirect_to contacts_url
  end
  
  private
  def get_contact
    @contact = Contact.find(params[:id])
  end

end
