require 'spec_helper'

describe RedisRedirect::Routes do
  include RSpec::Rails::RequestExampleGroup
  describe "routing" do    
    it "should redirect" do
      source, target = ['/my-redirect', '/go-over-there']
      Redirect.create(:source => source, :target => target)
      get(source)
      response.should redirect_to(target)
    end
  end
end
