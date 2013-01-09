require 'spec_helper'

describe Redirect do
  let(:random_key_value) {["/" + (0...8).map{65.+(rand(26)).chr}.join, '/target']}
  describe "save" do
    it "should create key value in redis" do
      key, value = random_key_value
      r = Redirect.new(:source => key, :target => value)
      r.save
      RedisRedirect.redis.get(key).should == value
    end
    it "should append a leading slash to all keys" do
      key, value = random_key_value
      r = Redirect.create(:source => key.gsub('/', ''), :target => value)
      RedisRedirect.redis.get(key).should == value
    end
    it "should return false when source is blank" do
      r = Redirect.new(:target => '/unicorn')
      r.save.should be_false
    end
  end
  
  describe "create" do
    it "create should save to redis" do
      key, value = random_key_value
      r = Redirect.create(:source => key, :target => value)
      RedisRedirect.redis.get(key).should == value
    end
  end
  
end