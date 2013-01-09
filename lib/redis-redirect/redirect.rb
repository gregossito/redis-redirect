require 'active_model/naming'
require 'active_model/validations'

class Redirect
  include ActiveModel::Validations

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
    "#<Redirect source: #{source.inspect}, target: #{target.inspect}"
  end
  
  # pretty much the same as an update, actually, yea
  def save
    RedisRedirect.redis.set(source, target)
  end
  alias :update :save
  
  # FIXME: this isn't really update_attributes
  def update_attributes(attributes = {})
    RedisRedirect.redis.set(attributes['source'], attributes['target'])
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
  
  def persisted?
    !(new_record? || destroyed?)
  end
  
  def destroyed?
    @destroyed
  end

  def new_record?
    !RedisRedirect.redis.get(source)
  end

  private

  def self.redis
    ::RedisRedirect.redis
  end
    
end
