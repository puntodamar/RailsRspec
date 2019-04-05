require 'rails_helper'

describe V1::CommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get "v1/articles/1/comments").to route_to("v1/comments#index", article_id: '1', :format => :json)
    end
    
    it "routes to #create" do
      expect(post "/v1/articles/1/comments").to route_to("v1/comments#create", article_id: '1', :format => :json)
    end
  end
end
