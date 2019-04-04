require 'rails_helper'

describe "access token routes", type: :routing do
    it "should route to access_tokens create action" do
        expect(post '/v1/login').to route_to('v1/access_tokens#create',:format => :json)
    end
    
    it "should route to access_tokens destroy action" do
        expect(delete '/v1/logout').to route_to('access_tokens#destroy', :format => :json)
    end
end