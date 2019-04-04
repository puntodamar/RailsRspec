require 'rails_helper'
require 'json'

describe V1::ArticlesController, type: :controller do
    
    subject { get :index }
    
    describe "#index" do
        it "should return success" do
            subject
            expect(response).to have_http_status(:ok)
        end
        
        it "should return proper json" do
            create_list :article, 2
            subject
            expect(json_data.length).to eq(2)
            Article.recent.each_with_index do |article, index|
                expect(json_data[index]["attributes"]).to eq({
                    "title"     => article.title,
                    "content"   => article.content,
                    "slug"      => article.slug
                })
            end
            
        end
        
        it "should return articles in the proper order" do
            old_article     = create :article
            newer_article   = create :article
            subject
            expect(json_data.first["id"]).to eq(newer_article.id.to_s)
            expect(json_data.last["id"]).to eq(old_article.id.to_s)
        end
        
        it "should paginate results" do
            create_list :article, 3
            get :index, params: {page: 2, per_page: 1}
            expect(json_data.length).to eq 1
            expected_article = Article.recent.second.id.to_s
            expect(json_data.first["id"]).to eq(expected_article)
        end
    end

    describe "#show" do
        let(:article) {create :article}
        subject{get :show, params: {id: article.id}}
        
        it "should return success response" do
            subject
            expect(response).to have_http_status(:ok)
        end
        
        it "should return proper json" do
            subject
            expect(json_data['attributes']).to eq({
                "title"     => article.title,
                "content"   => article.content,
                "slug"      => article.slug})
        end
    end
    
    describe "#create" do
        subject { post :create }
        context "when no code provided" do
            
            it_behaves_like "forbidden_requests"
        end
        
        context "when invalid code provided" do
           before {request.headers['authorization'] = "Invalid token"}
        
            it_behaves_like "forbidden_requests"
        end

        context "when authorized" do
            let(:user) {create :user}
            let(:access_token) {user.create_access_token}
            before {request.headers['authorization'] = "Bearer #{access_token.token}"}
    
            context "when invalid parameters provided" do
                let(:invalid_attributes) do
                    {
                        data: {
                            attributes: {
                                title: '',
                                content: ''
                            }
                        }
                    }
                end
                
                subject { post :create, params: invalid_attributes}
        
                it "should return 422 status code" do
                    subject
                    expect(response).to have_http_status(:unprocessable_entity)
                end
        
                it "should return proper error json" do
                    subject
                    expect(json['errors']).to include(
                        {
                            "source"   => {"pointer" => "/data/attributes/title"},
                            "detail"   => "can't be blank"
                        },
                        {
                            "source"   => {"pointer" => "/data/attributes/content"},
                            "detail"   => "can't be blank"
                        },
                        {
                            "source"   => {"pointer" => "/data/attributes/slug"},
                            "detail"   => "can't be blank"
                        },
                        )
                end
            end
    
            context "when success reequest sent" do
                let(:user) {create :user}
                let(:access_token) {user.create_access_token}
                let(:valid_attributes) do
                    {
                        "data" => {
                            "attributes" => {
                                "title"     =>  'Awesome Article',
                                "content"   =>  'Super content',
                                "slug"      =>  'awesome-article'
                            }
                        }
                    }
                end
                before {request.headers['authorization'] = "Bearer #{access_token.token}"}
                
                subject{ post :create, params: valid_attributes}
                
                it "should have 200 status code" do
                    subject
                    expect(response).to have_http_status(:created)
                end
                
                it "should have proper json body" do
                    subject
                    expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
                end
                
                it "should create the article" do
                    expect{subject}.to change{Article.count}.by(1)
                    
                end
            end
        end

    end

    describe "#update" do
        
        let(:article) {create :article}
        subject { patch :update, params: {id: article.id} }
        
        context "when no code provided" do
            it_behaves_like "forbidden_requests"
        end
    
        context "when invalid code provided" do
            before {request.headers['authorization'] = "Invalid token"}
            it_behaves_like "forbidden_requests"
        end
    
        context "when authorized" do
            let(:user) {create :user}
            let(:access_token) {user.create_access_token}
            before {request.headers['authorization'] = "Bearer #{access_token.token}"}
        
            context "when invalid parameters provided" do
                let(:invalid_attributes) do
                    {
                        data: {
                            attributes: {
                                title: '',
                                content: ''
                            }
                        },
                        id: article.id
                    }
                end
            
                subject { post :update, params: invalid_attributes}
            
                it "should return 422 status code" do
                    subject
                    expect(response).to have_http_status(:unprocessable_entity)
                end
            
                it "should return proper error json" do
                    subject
                    expect(json['errors']).to include(
                      {
                          "source"   => {"pointer" => "/data/attributes/title"},
                          "detail"   => "can't be blank"
                      },
                      {
                          "source"   => {"pointer" => "/data/attributes/content"},
                          "detail"   => "can't be blank"
                      }
                    )
                end
            end
        
            context "when success request sent" do
                let(:user) {create :user}
                let(:access_token) {user.create_access_token}
                let(:valid_attributes) do
                    {
                        "data"  => {
                            "attributes" => {
                                "title"     =>  'My awesome article 1',
                                "content"   =>  'The comment of my awesome article 1',
                                "slug"      =>  'my-awesome-article-1'
                            }
                        },
                        "id"    => article.id
                    }
                end
                before {request.headers['authorization'] = "Bearer #{access_token.token}"}
            
                subject{ post :update, params: valid_attributes}
            
                it "should have 200 status code" do
                    subject
                    expect(response).to have_http_status(:ok)
                end
            
                it "should have proper json body" do
                    subject
                    expect(json_data['attributes']).to include(valid_attributes['data']['attributes'])
                end
            
                it "should update the article" do
                    expect(article.reload.title).to eq(valid_attributes['data']['attributes']['title'])
            
                end
            end
        end

    end

end