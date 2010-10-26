class Contact < ActiveRecord::Base
  
  EMAIL_FORMAT = /^[^\s]+@[^\s]+\.[a-z]{2,}$/
  URL_FORMAT = /((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))+(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\&amp;%_\.\/-~-]*)?(?!['"]))|^\s*$/

  belongs_to :category, :class_name => 'ContactCategory'
  has_location  
  include TramlinesImages
  
  validates_presence_of :name
  validates_format_of :email, :with => EMAIL_FORMAT, :allow_blank => true
  validates_format_of :website, :with => URL_FORMAT, :allow_blank => true
  
  alias_attribute :address, :location
  
end
