class ContactsController < ApplicationController

  include ContactsMap
    
  admin_only :create, :destroy, :edit, :new, :update
  
  before_filter :get_contact, :only => %w{show edit update destroy}
  
  def create
    @contact = Contact.new(params[:contact])
    if @contact.save
      flash[:notice] = "Successfully created contact."
      redirect_to @contact
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @contact.destroy
    flash[:notice] = "Successfully deleted contact."
    redirect_to contacts_url
  end
  
  def edit
  end
  
  def index
    if params[:id] == '#'
      @contacts = Contact.find(:all, :conditions => "name BETWEEN '0%' AND '9%'", :order=>'name').paginate :page => params[:page], :per_page => 50
    else
      params[:id] ||= 'A'
      @contacts = Contact.name_begins_with(params[:id]).ascend_by_name.paginate :page => params[:page], :per_page => 50
    end
    @contact_categories = ContactCategory.all(:order => 'name')
    @a_to_z = true
    initialize_map(Contact.all)
  end
  
  def new
    @contact = Contact.new
  end
  
  def show
  end
  
  def update
    if @contact.update_attributes(params[:contact])
      flash[:notice] = "Successfully updated contact."
      redirect_to @contact
    else
      render :action => "edit"
    end
  end
  
  private
  def get_contact
    @contact = Contact.find(params[:id])
  end

end
