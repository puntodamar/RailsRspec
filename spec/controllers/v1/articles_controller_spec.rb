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
            articles = create_list :article, 2
            subject
            expect(json_data.length).to eq(2)
            articles.each_with_index do |article, index|
                expect(json_data[index]["attributes"]).to eq({
                    "title"     => article.title,
                    "content"   => article.content,
                    "slug"      => article.slug
                })
            end
            
        end
    end
end