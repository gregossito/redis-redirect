# RedisRedirect

Simple redirector for a Rails app.  Stores the key in redis (using namespace to stay out of the way) and redirects to the value. 

it's a gem, do all that Gemfile stuff: 

    gem 'redis-redirect'

create a config/initializer/redis_redirect.rb like:

    # Load config and set redis.
    redis_config = YAML.load_file(rails_root + '/config/redis.yml')[rails_env]
    RedisRedirect.redis = Redis.connect(:url => "redis://#{redis_config['host']}/#{redis_config['db']}")

    # Set namespace to prevent collisions
    RedisRedirect.redis.namespace = "redis_redirect"  # default is redis_redirect

and hook it up to your routes file:
    
    get "*path" => RedisRedirect

remember routes are run in order, you probably want the redirect pretty low.
