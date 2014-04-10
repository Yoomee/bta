class MobileController < ApplicationController
  def toggle
    render :update do |page|
      puts "Session  #{session[:mobile_view]}"
      session[:mobile_view] = !session[:mobile_view]
      page << "history.go(0)"
    end
  end
end