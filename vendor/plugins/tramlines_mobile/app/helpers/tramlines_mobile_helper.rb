module TramlinesMobileHelper
  
  def mobile_view?
    session[:mobile_view] == true
  end
  
end