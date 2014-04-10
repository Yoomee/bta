class Payment < ActiveRecord::Base
  
  belongs_to :attachable, :polymorphic => true

  validates_presence_of :attachable, :payment_pence, :reference, :uk_taxpayer
  validates_uniqueness_of :reference
  
  class << self
    
    def generate_reference
      time_string = Time.now.strftime("%Y%m%d%k%M%S")
      ref = maximum(:id).to_i + 1
      while exists?(:reference => "#{ref}-#{time_string}")
        ref = ref + 1
      end
      "#{ref}-#{time_string}"
    end
    
  end

  def payment_pounds
    payment_pence.to_f / 100
  end
  
end