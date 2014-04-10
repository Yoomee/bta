require 'forwardable'
class CartItem < ActiveRecord::Base

  extend Forwardable
  
  belongs_to :cart
  belongs_to :product

  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  validates_presence_of(:cart_id, :product_id, :quantity)

  def_delegator :product, :name, :product_name
  def_delegator :product, :price_in_pence, :product_price_in_pence
  def_delegator :product, :price_in_pounds, :product_price_in_pounds
  def_delegator :product, :sku

  after_save :destroy_if_empty
  
  def add_quantity(n)
    self.quantity = new_record? ? n : quantity + n.to_i
  end
  
  def empty?
    quantity < 1
  end

  def price_in_pounds
    quantity * product_price_in_pounds
  end

  private
  def destroy_if_empty
    quantity.zero? ? self.destroy : true
  end
  
end
