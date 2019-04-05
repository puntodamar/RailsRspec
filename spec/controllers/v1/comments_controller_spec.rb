require 'rails_helper'

describe V1::CommentsController, type: :controller do
    describe "GET #index" do
        
        let(:article) {create :article}
        
        it "returns a success response" do
            get :index, params: {article_id: article.id}
            expect(response).to have_http_status(:ok)
        end
    end
end
