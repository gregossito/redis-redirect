module RedisRedirect
  class Routes
    def self.call(env)
      relative_path = env["PATH_INFO"]

      return continue_to_rails_stack if relative_path.nil?

      begin
        new_location_path = RedisRedirect.redis.get(relative_path)
      rescue Redis::CannotConnectError => exception
        new_location_path = nil
      end
      
      if new_location_path.nil?
        continue_to_rails_stack
      else
        host = env["HTTP_X_FORWARDED_HOST"] || env["HTTP_HOST"]
        path = new_location_path.match(/^\//) ? build_url(host, new_location_path) : new_location_path
        redirect_to path
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
