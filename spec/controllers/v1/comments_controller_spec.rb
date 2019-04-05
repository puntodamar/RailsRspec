require 'rails_helper'

describe V1::CommentsController, type: :controller do
    let(:user) {create :user}
    let(:article) {create :article, user: user}
    
    describe "GET #index" do
        
        subject {get :index, params: {article_id: article.id, user_id: user}}
        
        it "returns a success response" do
            subject
            expect(response).to have_http_status(:ok)
        end
        
        it "should return only comments belonging to article" do
            user2    = create :user
            comment1 = create :comment, article: article, user: user
            article2 = create :article, user: user2
            create :comment, article: article2, user: user2
            subject
            expect(json_data.length).to eq(1)
            expect(json_data.first['id']).to eq(comment1.id.to_s)
        end
        
        it "should paginate" do
            comments = create_list :comment, 3, article: article, user: user
            get :index, params: {article_id: article.id, per_page: 1, page: 2}
            
            expect(json_data.length).to eq(1)
            comment = comments.second
            expect(json_data.first['id']).to eq(comment.id.to_s)
        end
        
        it "should have proper json body" do
            comment = create :comment, article: article, user: user
            subject
            expect(json_data.first['attributes']).to eq({'content' => comment.content})
        end
        
        it "should have related objecs information in the response" do
            create :comment, article: article, user: user
            subject
            relationships = json_data.first['relationships']
            pp relationships
            expect(relationships['article']['data']['id']).to eq(article.id.to_s)
            expect(relationships['user']['data']['id']).to eq(user.id.to_s)
        end
    end
    
    describe "POST #create" do
        let(:valid_attributes) {{content: "My awesome comment for article"}}
        let(:invalid_attributes) {{content: ''}}
        
        context "when unauthorized" do
            subject {post :create, params: {article_id: article.id}}
            it_behaves_like "forbidden_requests"
        end
        
        context "when authorized" do
        
        end
    end
end
