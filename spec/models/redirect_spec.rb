require 'spec_helper'

describe Redirect do
  let(:random_key_value) {["/" + (0...8).map{65.+(rand(26)).chr}.join, 'target']}
  it "save should create key value in redis" do
    key, value = random_key_value
    r = Redirect.new(:source => key, :target => value)
    r.save
    RedisRedirect.redis.get(key).should == value
  end
  
  it "create should save to redis" do
    key, value = random_key_value
    r = Redirect.create(:source => key, :target => value)
    RedisRedirect.redis.get(key).should == value
  end

end