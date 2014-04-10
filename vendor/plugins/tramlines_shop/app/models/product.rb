require 'forwardable'
class Product < ActiveRecord::Base

  has_many :photos, :class_name => 'ProductPhoto'
  extend TramlinesImages::ClassMethods

  extend Forwardable

  acts_as_taggable

  belongs_to :department
  has_many :photos, :class_name => 'ProductPhoto', :dependent => :destroy
  
  validate :sku_must_be_valid
  validates_numericality_of :price_in_pence
  validates_presence_of :department_id
  validates_presence_of :name
  has_breadcrumb_parent :department
  
  #after_save :save_photos
  
  named_scope :active, :joins => :department, :conditions => "products.deleted_at IS NULL AND departments.deleted_at IS NULL AND departments.hidden = 0"

  def active?
    !deleted?
  end
  
  def default_image(image_attr = 'image')
    self.class::default_image(image_attr)
  end
  
  def deleted?
    !deleted_at.blank?
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
  end
  
  def has_image?(attr = 'image')
    photos.first.try(:has_image?, attr)
  end
  
  def image
    photos.first.try(:image)
  end

  def image=(val)
    photos.clear
    photos.build(:image => val)
  end
  
  def price_in_pounds
    price_in_pence.to_f / 100
  end

  def price_in_pounds=(val)
    self.price_in_pence = val.to_f * 100
  end
  
  def sku
    read_attribute(:sku) || id
  end

  def sku=(ud_sku)
    write_attribute :sku, ud_sku.upcase
  end

  def sku_already_exists?
    ![self, nil].include? Product.find_by_sku(sku)
  end

  def sku_is_id?
    sku == id.to_s
  end
  
  def sku_must_be_valid
    unless read_attribute(:sku).blank?
      errors.add(:sku, 'must include a letter') if sku.match(/^\d+$/) && !sku_is_id?
      errors.add(:sku, 'can only contain letters and numbers') if sku.match /[^A-Za-z0-9]+/
      errors.add(:sku, 'already exists') if sku_already_exists?
    end
  end

  def to_s
    name
  end

  private
  def save_photos
    photos.each do |photo|
      photo.changed?
      photo.save!
    end
  end
end
