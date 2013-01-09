module RedisRedirect
  class Route
    def call(env)
      redis.get("/foobar")
      
      relative_path = env["PATH_INFO"]

      return continue_to_rails_stack if relative_path.nil?
      return redis_stats if relative_path == "/redis-stats"
    
      begin
        new_location_relative_path = Redirect.get_target_url(relative_path)
      rescue Redis::CannotConnectError => exception
        notify_airbrake exception if Rails.env.production?
        new_location_relative_path = nil
      end
      
      if new_location_relative_path.nil?
        continue_to_rails_stack
      else
        host = env["HTTP_X_FORWARDED_HOST"] || env["HTTP_HOST"]
        permanent_redirect build_url(host, new_location_relative_path)
      end
    end
  end
end
