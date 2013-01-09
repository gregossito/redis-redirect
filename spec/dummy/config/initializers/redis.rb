RedisRedirect.redis = Redis.connect(:url => "redis://localhost:6379/3")
RedisRedirect.redis.namespace = "redirect"  # default is redis_redirect
