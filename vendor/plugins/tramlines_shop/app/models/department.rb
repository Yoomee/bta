class Department < ActiveRecord::Base

  belongs_to :member
  has_many :products, :dependent => :destroy

  default_scope :order => 'weight'

  validates_presence_of :name

  has_ancestry

  has_breadcrumb_parent :parent

  named_scope :active, :conditions => "deleted_at IS NULL && hidden = 0"
  named_scope :not_deleted, :conditions => "deleted_at IS NULL"
  
  def all_active_children
    products.active + children.active
  end
  
  def all_children
    products + children
  end
  
  def all_descendants
    descendants_list = all_children
    descendants.each do |child|
      descendants_list << child.all_descendants
    end
    descendants_list.flatten
  end
  
  def breadcrumb
    if is_root?
      [['Shop', '/shop'], self]
    else
      parent.breadcrumb + [self]
    end
  end
  
  def destroy
    update_attribute(:deleted_at, Time.now)
  end
  
  def has_descendant?(product_or_department)
    all_descendants.include? product_or_department
  end
  
  def name_with_depth(indent)
    (indent * depth) + name
  end
  
  def to_s
    name
  end

end
