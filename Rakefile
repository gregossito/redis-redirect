#!/usr/bin/env rake
begin
  ENV['BUNDLE_GEMFILE'] = File.dirname(__FILE__) + '/Gemfile'
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

require 'rspec'
require 'rspec/core/rake_task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RedisRedirect'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

namespace :spec do
  desc "Verify config file"
  task :setup do
    puts "Specs require a spec/dummy/redis.yml file" if !File.exists?(File.expand_path(File.dirname(__FILE__) + '/spec/dummy/redis.yml'))
  end
  
  desc "redis-redirect models"
  RSpec::Core::RakeTask.new(:redis_model) do |task|
    redis_redirect_root = File.expand_path(File.dirname(__FILE__))
    task.pattern = redis_redirect_root + '/spec/models/*_spec.rb'
    puts task.pattern
  end
  
  desc "redis-redirect router"
  RSpec::Core::RakeTask.new(:redis_routes) do |task|
    redis_redirect_root = File.expand_path(File.dirname(__FILE__))
    task.pattern = redis_redirect_root + '/spec/routing/*_spec.rb'
    puts task.pattern
  end

  # desc "Run the coverage report"
  # RSpec::Core::RakeTask.new(:rcov) do |task|
  #   slugger_root = File.expand_path(File.dirname(__FILE__) + '/..')
  #   task.pattern = slugger_root + '/spec/lib/**/*_spec.rb'
  #   task.rcov=true
  #   task.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/}
  # end
end

desc "Run the test suite"
task :spec => ['spec:setup', 'spec:redis_model', 'spec:redis_routes']

task :default => :spec
