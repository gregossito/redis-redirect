module RedisRedirect
  class Routes
    def self.call(env)
      relative_path = env["PATH_INFO"]

      return continue_to_rails_stack if relative_path.nil?

      begin
        new_location_relative_path = redis.get(relative_path) #Redirect.get_target_url(relative_path)
      rescue Redis::CannotConnectError => exception
        new_location_relative_path = nil
      end
      
      if new_location_relative_path.nil?
        continue_to_rails_stack
      else
        host = env["HTTP_X_FORWARDED_HOST"] || env["HTTP_HOST"]
        redirect_to build_url(host, new_location_relative_path)
      end
    end
    
    def self.redirect_to(location) 
      [302, {"Content-Type" => "text/html", "Location" => location}, ["Redirecting..."]]    
    end
    
    def self.build_url(host, relative_path)
      "http://" + host + relative_path 
    end
    
    def self.continue_to_rails_stack
      [404, {"Content-Type" => "text/html", "X-Cascade" => "pass"}, ["Not Found"]]
    end
  end
end
