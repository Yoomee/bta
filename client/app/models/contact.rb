# require 'forwardable'
class Contact < ActiveRecord::Base
  
  extend Forwardable
  DEFAULT_ZOOM = 10

  include TramlinesImages
  
  belongs_to :category, :class_name => 'ContactCategory'
  has_location  
  
  validates_presence_of :name
  validates_email_format_of :email, :allow_blank => true
  validates_url_format_of :website, :allow_blank => true
  
  alias_attribute :address, :location
  
  alias_attribute :to_s, :name
  
  search_attributes %w{name}  
  
end
