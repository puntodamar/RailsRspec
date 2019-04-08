require 'rails_helper'

shared_examples_for "unauthorized_oauth_requests" do
    let(:authentication_error) do
        {
            "status"    => "401",
            "source"    => {"pointer" => "/code"},
            "title"     => "Authentication code is invalid",
            "details"   => "You must provide valid code in order to exchange it for token."
        }
    end
    
    it "should return 401 status code" do
        subject
        expect(response).to have_http_status(401)
    end
    
    it "should return proper error body" do
        subject
        expect(json["error"]).to include(authentication_error)
    end
end

shared_examples_for "unauthorized_standard_requests" do
    let(:authentication_error) do
        {
            "status"    => "401",
            "source"    => {"pointer" => "/data/attributes/password"},
            "title"     => "invalid username / password",
            "details"   => "You must provide valid credentials to exchange it for token."
        }
    end
    
    it "should return 401 status code" do
        subject
        expect(response).to have_http_status(401)
    end
    
    it "should return proper error body" do
        subject
        expect(json["error"]).to include(authentication_error)
    end
end

shared_examples_for "forbidden_requests" do
    let(:authorization_error) do
        {
            "status"    => "403",
            "source"    => {"pointer" => "/headers/authorization"},
            "title"     => "Not authorized",
            "details"   => "You have no right to access this resource."
        }
    end
    
    it "should return 403 status code" do
        subject
        expect(response).to have_http_status(403)
    end
    
    it "should return proper error body" do
        subject
        expect(json["errors"]).to include(authorization_error)
    end
end