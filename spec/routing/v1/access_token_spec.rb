require 'rails_helper'

describe "access token routes", type: :routing do
    it "should route to access_tokens create action" do
        expect(post '/v1/login').to route_to('v1/access_tokens#create',:format => :json)
    end
end