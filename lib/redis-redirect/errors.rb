module RedisRedirect
  class RedisRedirectError < StandardError
  end
  
  class RecordNotSaved < RedisRedirectError
  end
  
  class RecordNotDestroyed < RedisRedirectError
  end
end