module TramlinesPayments::HasPayment
  
  def self.included(klass)
    klass.has_one :payment, :as => :attachable
    klass.delegate :response_message, :to => :card_details, :prefix => true
    klass.delegate :complete_payment!, :to => :card_details
    klass.validates_associated :card_details
  end
  
  attr_reader :card_details
  
  def payment_reference
    @payment_reference ||= Payment.generate_reference
  end
  
  def payment_reference=(value)
    @payment_reference ||= value
  end
  
  def build_card_details(attrs = {})
    @card_details ||= CardDetails.new(attrs.merge(:attachable => self))
  end
  
  def card_details=(attrs)
    attrs.merge!(:attachable => self)
    @card_details = CardDetails.new(attrs)
  end
  
end