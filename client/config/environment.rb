class ClientEnvironment

  class << self
    def setup(config)
      config.gem 'yoomee-searchlogic', :lib => 'searchlogic'      
    end
  end

end
