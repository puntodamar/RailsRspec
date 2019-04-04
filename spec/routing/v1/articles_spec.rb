require 'rails_helper'

describe "article routes", type: :routing do
    it "should route to index" do
        expect(get '/v1/articles').to route_to('v1/articles#index', :format => :json)
    end

    it "should route to articles show" do
        expect(get '/v1/articles/1').to route_to('v1/articles#show', id: '1', :format => :json)
    end
    
    it "should route to articles create" do
        expect(post '/v1/articles').to route_to('v1/articles#create', :format => :json)
    end
    
    it "should route to articles update" do
        expect(put '/v1/articles/1').to route_to('v1/articles/#update', id: '1', :format => :json)
        expect(patch '/v1/articles/1').to route_to('v1/articles/#update', id: '1', :format => :json)
    end
    
    
end