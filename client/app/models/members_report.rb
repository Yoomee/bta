MembersReport.class_eval do
  
  class << self
    def field_names
      [:email, :username, :password, :surname, :forename, :ip_address, :created_at, :updated_at]
    end
  
    def headings
      ["Email", "Username", "Password", "Surname", "Forename", "IP Addresses", "Created At", "Updated At"]
    end
  end
end
  
MembersReport::Row.class_eval do
  
    def ip_address
      @member.ip_address
    end
    
    def password
      @member.password
    end

end
