# -----------------------------------------------------------------------
#
# Copyright (c) andymayer.net Ltd, 2007-2008. All rights reserved.
 
# This software was created by andymayer.net and remains the copyright
# of andymayer.net and may not be reproduced or resold unless by prior
# agreement with andymayer.net.
#
# You may not modify, copy, duplicate or reproduce this software, or
# transfer or convey this software or any right in this software to anyone
# else without the prior written consent of andymayer.net; provided that
# you may make copies of the software for backup or archival purposes
# 
# andymayer.net grants you the right to use this software solely
# within the specification and scope of this project subject to the
# terms and limitations for its use as set out in the proposal.
# 
# You are not be permitted to sub-license or rent or loan or create
# derivative works based on the whole or any part of this code
# without prior written agreement with andymayer.net.
# 
# -----------------------------------------------------------------------
require 'forwardable'

ActiveMerchant::Billing::Base.mode = :test if RAILS_ENV.in? %w{development test}

class CardDetails < Tableless

  extend Forwardable

  attr_accessor :attachable, :address1, :address2, :card_number, :card_type, :cardholder_name, :city, :county, :country, :issue_number, :postcode, :security_number, :start_date
  attr_writer :expiry_date
  attr_reader :response_message, :response_security_key, :response_vps_tx_id, :uk_taxpayer

  attr_boolean_accessor :uk_taxpayer
  
  def_delegator :@response, :message, :response_message

  validates_presence_of :address1, :city, :postcode, :country
  #validates_presence_of :uk_taxpayer, :message => "please select if you are a UK taxpayer"
  
  def attachable_id
    attachable.try(:id)
  end
  
  def attachable_type
    attachable.nil? ? nil : attachable.class.to_s
  end
  
  def attributes=(attributes)
    attributes['start_date_year'] = attributes.delete('start_date(1i)') if attributes.key?('start_date(1i)')
    attributes['start_date_month'] = attributes.delete('start_date(2i)') if attributes.key?('start_date(2i)')
    attributes.delete('start_date(3i)')
    attributes['expiry_date_year'] = attributes.delete('expiry_date(1i)') if attributes.key?('expiry_date(1i)')
    attributes['expiry_date_month'] = attributes.delete('expiry_date(2i)') if attributes.key?('expiry_date(2i)')
    attributes.delete('expiry_date(3i)')
    attributes.each do |k, v|
      send("#{k}=", v)
    end
    update_dates!
  end
  
  def complete_payment!(options = {})
    options.reverse_merge!(:description => "#{attachable_type} #{attachable_id}")
    amount, reference, description = options[:amount], options[:reference], options[:description]
    card = get_active_merchant_credit_card
    gateway = get_gateway(:protx)
    response = gateway.purchase(amount, card, :order_id => reference, :description => description, :address => active_merchant_address_hash)
    @response = response
    p "@response = #{@response.inspect}"
    if response.success?
      attachable.create_payment(:reference => reference, :payment_pence => amount, :uk_taxpayer => uk_taxpayer)
    else
      raise(PaymentFailedError, @response.message)
    end
  end
  
  def expiry_date
    @expiry_date || Date.today
  end
  
  def expiry_date_month=(month)
    @expiry_date_month = month.to_i
  end
  
  def expiry_date_year=(year)
    @expiry_date_year = year.to_i
  end
  
  def initialize(attributes = {})
    self.attributes = attributes
  end
  
  def obfuscated_card_number
    #{}"#### #### #### #{card_number[12, 4]}"
    card_number[card_number.length - 4, 4].rjust(card_number.length, '#')
  end

  def response_authorization_number
    @response.params['TxAuthNo']
  end

  def response_security_key
    @response.params['SecurityKey']
  end
  
  def response_vps_tx_id
    @response.params['VPSTxId']
  end
  
  def start_date_month=(month)
    @start_date_month = month.to_i
  end
  
  def start_date_year=(year)
    @start_date_year = year.to_i
  end
  
  def update_attributes(attributes)
    self.attributes=(attributes)

    attributes.each do |key, value|
      send("#{key}=", value)
    end
    valid?
  end

  def valid?
    errors.clear
    card = get_active_merchant_credit_card
    ret = super & card.valid?
    map_card_errors_to_fields(card.errors) if card.errors
    ret
  end

  private
  def active_merchant_address_hash
    {
      :address1 => address1,
      :address2 => address2,
      :city => city,
      :state => county,
      :country => country,
      :zip => postcode,
    }
  end
  
  def get_active_merchant_credit_card
    active_merchant_card = ActiveMerchant::Billing::CreditCard.new(
      :name => cardholder_name,
      :month => expiry_date.month,
      :year => expiry_date.year,
      :type => card_type,
      :number => card_number,
      :verification_value => security_number,
      :issue_number => issue_number
    )
    #active_merchant_card.type = 'bogus' # whilst testing
    if start_date
      active_merchant_card.start_month = start_date.month
      active_merchant_card.start_year = start_date.year
    end
    active_merchant_card
  end
  
  def get_gateway gateway_type
    case gateway_type
      when :protx
        ret = ActiveMerchant::Billing::ProtxGateway.new :login => APP_CONFIG["sagepay_vendor_name"]
        ret
    end
  end
  
  # Maps ActiveMerchant errors onto CardDetails fields
  def map_card_errors_to_fields(card_errors)
    card_errors.each do |attr, msg|
      card_details_attr = ACTIVE_MERCHANT_TO_CARD_DETAILS_FIELD_MAPPINGS[attr] || attr
      card_details_error = ACTIVE_MERCHANT_TO_CARD_DETAILS_ERROR_MAPPINGS[msg.to_s] || msg.to_s
      errors.add(card_details_attr, card_details_error)
    end
  end
  
  def update_dates!
    update_start_date!
    update_expiry_date!
  end
  
  def update_expiry_date!
    if @expiry_date_year || @expiry_date_month
      self.expiry_date = (@expiry_date_year.zero? || @expiry_date_month.zero?) ? nil : Date.new(@expiry_date_year, @expiry_date_month, 1)
    end
  end
  
  def update_start_date!
    if @start_date_year || @start_date_month
      self.start_date = (@start_date_year.zero? || @start_date_month.zero?) ? nil : Date.new(@start_date_year, @start_date_month, 1)
    end
  end

  private
  class PaymentFailedError < Exception
  end
  
end

CardDetails::ACTIVE_MERCHANT_TO_CARD_DETAILS_ERROR_MAPPINGS = {'expiredis not a valid year' => 'must be in the future', 'expired' => 'must be in the future'}
CardDetails::ACTIVE_MERCHANT_TO_CARD_DETAILS_FIELD_MAPPINGS = {'number' => 'card_number', 'type' => 'card_type', 'verification_value' => 'security_number', 'year' => 'expiry_date', 'name' => 'cardholder_name'}

CardDetails::CARD_TYPES = {'visa' => 'Visa',
                           'master'   => 'Mastercard',
                           'solo' => 'Solo',
                           'maestro' => 'Maestro/Switch',
                           'american_express' => 'American Express',
                           'diners_club' => 'Diners Club',
                           'jcb' => 'JCB'}
