# RedisRedirect

Simple redirector for a Rails app.  Stores the key in redis (using namespace
to stay out of the way) and redirects to the value.

it's a gem, do all that Gemfile stuff: 

    gem 'redis-redirect'

create a config/initializer/redis_redirect.rb like:

    # Load config and set redis.
    redis_config = YAML.load_file(rails_root + '/config/redis.yml')[rails_env]
    RedisRedirect.redis = Redis.connect(:url => "redis://#{redis_config['host']}/#{redis_config['db']}")

    # Set namespace to prevent collisions
    RedisRedirect.redis.namespace = "redis_redirect"  # default is redis_redirect

and hook it up to your routes file:
    
    get "*path" => RedisRedirect::Routes

remember routes are run in order, you probably want the redirect pretty low. If
the route is not matched, or the connection fails it will just continue down
the routes.

This gem creates a model, Redirect, that has source and target instance
variables. The Redirect model tries to act a bit like an ActiveRecord object
so that form generation is easy. Notable differences is that there is no id
field since the datastore is redis. Instead it uses the key to act as a
to_param. so:

    r = Redirect.new(source: '/some-old-path', target: '/new-hotness')
    r.save
    
    same_r = Redirect.find('/some-old-path')
    same_r.destroy # works

Should work with Rails 3+, patches welcome.
