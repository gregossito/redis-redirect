module RedisRedirect
  # Tries to apply the same interface used by ActiveRecord::Persistence
  # to redis, when it makes sense, for simple use with scaffolded controllers
  # http://api.rubyonrails.org/classes/ActiveRecord/Persistence.html
  module Persistence
    extend ActiveSupport::Concern

    module ClassMethods
      def create(attributes = nil)
        object = new(attributes)
        object.save
        object
      end
    end

    def new_record?
      !RedisRedirect.redis.get(source)
    end

    def destroyed?
      @destroyed
    end

    def persisted?
      !(new_record? || destroyed?)
    end

    # pretty much the same as an update, actually, yea
    def save
      create_or_update
    end
    alias :update :save

    def save!
      create_or_update || raise(RecordNotSaved)
    end
    alias :update! :save!

    def destroy
      result = 1 == RedisRedirect.redis.del(source)
      @destroyed = true
      freeze
      result
    end
    alias :delete :destroy

    def destroy!
      destroy || raise(RecordNotDestroyed)
    end

    def update_attributes(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      source = attributes['source'] if attributes.has_key?('source')
      target = attributes['target'] if attributes.has_key?('target')
      save
    end
    def update_attributes!(attributes = {})
      update_attributes(attributes)
      save!
    end

  private
    def create_or_update
      "OK" == RedisRedirect.redis.set(source, target)
    end
  end
end