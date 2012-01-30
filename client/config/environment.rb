class ClientEnvironment

  class << self
    def setup(config)
      config.gem 'yoomee-searchlogic', :lib => 'searchlogic'
      config.gem 'facebooker2'       
    end
  end

end
