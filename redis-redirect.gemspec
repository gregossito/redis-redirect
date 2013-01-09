$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "redis-redirect/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "redis-redirect"
  s.version     = RedisRedirect::VERSION
  s.authors     = ["Seth Faxon"]
  s.email       = ["seth.faxon@gmail.com"]
  s.homepage    = "http://github.com/marshill/redis-redirect"
  s.summary     = "Redirects stored in redis."
  s.description = "RedisRedirect allows dynamic Rails app redirects."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_dependency "redis-namespace", "~> 1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
end
