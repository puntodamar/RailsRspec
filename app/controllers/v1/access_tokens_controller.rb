class V1::AccessTokensController < ApplicationController
    
    skip_before_action :authorize!, only: :create
    
    def create
        authenticator = UserAuthenticator.new(auth_params)
        authenticator.perform
        
        render json: authenticator.access_token, status: :created
    end
    
    def destroy
        current_user.access_token.destroy
        render json: {}, status: :no_content
    end
    
    private
    
    def auth_params
        params.permit(:code).to_h.symbolize_keys
    end
    
end

