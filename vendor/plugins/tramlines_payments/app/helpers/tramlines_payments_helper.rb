module TramlinesPaymentsHelper
  
  # Provides months in the form ['01 - Jan', '02 - Feb', etc]
  def card_month_names
    (1..12).to_a.map do |num|
      "#{num.to_s.rjust 2, '0'} - #{Date::ABBR_MONTHNAMES[num]}"
    end
  end
  
  def card_types_array
    CardDetails::CARD_TYPES.collect {|card_type_value, card_type_label| [card_type_label, card_type_value]}
  end
  
end