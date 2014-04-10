class Order < ActiveRecord::Base

  include AASM
  
  has_many :lines, :class_name => 'OrderLine', :dependent => :destroy
  has_many :products, :through => :lines

  has_location
  has_multiple_form_steps
  has_payment


  validates_presence_of :email, :forename, :surname
  validates_email_format_of :email  
  
  accepts_nested_attributes_for :location
  
  attr_boolean_accessor :deliver_to_billing_address

  before_validation :set_delivery_address_if_billing_address
  before_validation :set_transaction_reference
  

  aasm_initial_state :placed

  aasm_state :placed
  aasm_state :dispatched
  aasm_state :cancelled

  aasm_event :cancel, :before => :updated_cancelled_at do
    transitions :to => :cancelled, :from => :placed
  end

  aasm_event :dispatch, :before => :update_dispatched_at do
    transitions :to => :dispatched, :from => :placed
  end

  class << self
    
    def find_with_hashed_reference(*args)
      if args.first.is_a?(Symbol)
        find_without_hashed_reference(*args)
      else
        find_by_hashed_reference(*args)
      end
    end
    alias_method_chain :find, :hashed_reference
    
  end

  def amount_in_pence
    lines.inject(0) do |memo, item|
      memo + item.amount_in_pence
    end
  end
  
  def amount_in_pounds
    amount_in_pence.to_f / 100
  end
   
  def cart=(cart)
    cart.items.each do |item|
      lines.build(:cart_item => item)
    end
  end
  
  def complete_payment!
    card_details.complete_payment!(:amount => amount_in_pence, :reference => payment_reference)
  end

  def delivery_address
    location
  end
  
  def full_name
    "#{forename} #{surname}"
  end
  
  def initialize(attrs = {})
    attrs ||= {}
    super(attrs.reverse_merge(:deliver_to_billing_address => true))
  end

  def new_record_with_reset?
    new_record_without_reset? || hashed_reference.nil?
  end
  alias_method_chain :new_record?, :reset

  def reset!
    # Needed to fix problem with transaction not resetting instance data on rollback
    self.hashed_reference = nil
  end

  def to_param
    new_record? ? nil : hashed_reference
  end
  
  def status
    aasm_state.to_s.humanize
  end
  
  def to_s
    transaction_reference
  end
  
  private
  def set_delivery_address_if_billing_address
    if deliver_to_billing_address? && card_details
      self.location ||= build_location
      %w{address1 address2 city postcode country}.each do |attr|
        location.send("#{attr}=", card_details.send(attr))
      end
    end
  end
  
  def set_transaction_reference
    self.transaction_reference = payment_reference
    self.hashed_reference = Digest::MD5.hexdigest("#{SALT}#{transaction_reference}")
  end
  
  def updated_cancelled_at
    self.cancelled_at = Time.zone.now
  end
  
  def update_dispatched_at
    self.dispatched_at = Time.zone.now
  end
    
end

Order::SALT = "NaCl"