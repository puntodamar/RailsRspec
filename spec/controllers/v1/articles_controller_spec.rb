require 'rails_helper'

describe V1::ArticlesController, type: :controller do
    describe "#index" do
        it "should return success" do
            get :index
            expect(response).to have_http_status(:ok)
        end
        
        it "should return proper json" do
            create_list :article, 2
            get :index
            json = JSON.parse(response.body)
            pp json
            # data = json[:data]
            # expect(data.length).to eq(2)
        end
    end
end