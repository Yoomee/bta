class Cart < ActiveRecord::Base
  
  belongs_to :member
  has_many :items, :class_name => 'CartItem', :dependent => :destroy

  accepts_nested_attributes_for :items

  def contains_item?(cart_item)
    items.any? {|item| item == cart_item}
  end

  def empty?
    items.all?(&:empty?)
  end
  
  def item_count
    items.inject(0) {|sum, item| sum += item.quantity}
  end

  def payment_reference
    @payment_reference ||= Time.now.strftime("#{id}-%Y%m%d%H%M")
  end
  
  def paypal_url
    return nil if !APP_CONFIG[:paypal_business_email]
    values = {
      :business => APP_CONFIG[:paypal_business_email],
      :cmd => '_cart',
      :currency_code => 'GBP',
      :upload => 1,
      :invoice => id,
      :shipping => 0,
      :no_shipping => 2,
      :invoice => payment_reference
    }
    items.each_with_index do |item, idx|
      n = idx + 1
      values["item_name_#{n}".to_sym] = URI::escape(item.product_name)
      values["quantity_#{n}".to_sym] = item.quantity
      values["amount_#{n}".to_sym] = item.product_price_in_pounds
    end
    url = RAILS_ENV.in?(%w{development test}) ? "https://www.sandbox.paypal.com/cgi-bin/webscr?" : "https://www.paypal.com/cgi-bin/webscr?"
    url << values.map {|k, v| "#{k}=#{v}"}.join('&')
    puts "url = #{url}"
    url
  end
  
  def total_in_pounds
    items.inject(0.0) do |memo, item|
      memo + item.price_in_pounds
    end
  end

end
