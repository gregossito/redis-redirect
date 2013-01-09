require 'active_model/naming'
require 'active_model/validations'

class Redirect
  include ActiveModel::Validations
  include RedisRedirect::Persistence

  extend ActiveModel::Naming
    
  attr_accessor :source, :target
  attr_reader :destroyed, :new_record
  

  # this is really slow, blocks redis, should find alternative
  # but it should also only be used administratively
  def self.all
    RedisRedirect.redis.keys.map do |x|
      self.new(:source => x, :target => RedisRedirect.redis.get(x) )
    end
  end
  
  def self.find(source)
    target = RedisRedirect.redis.get(source)
    target ? self.new(:source => source, :target => target) : nil
  end

  def initialize(options = {})
    @source = options[:source]
    @target = options[:target]
    @destroyed = false
  end
  
  def inspect
    "#<Redirect source: #{source.inspect}, target: #{target.inspect}>"
  end
  
  def id
    nil
  end

  def to_param
    source ? source.gsub('/', '%2F') : nil
  end

  # MODULE ActiveRecord::AttributeMethods::PrimaryKey
  def to_key
    [to_param]
  end
    
end
