MembersReport.class_eval do
  
  class << self
    def field_names
      [:email, :username, :password, :surname, :forename, :created_at, :updated_at]
    end
  
    def headings
      ["Email", "Username", "Password", "Surname", "Forename", "Created At", "Updated At"]
    end
  end
end
  
MembersReport::Row.class_eval do
    
    def password
      @member.password
    end

end
