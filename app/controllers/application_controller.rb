class ApplicationController < ActionController::API
    
    class AuthorizationError < StandardError; end

    rescue_from UserAuthenticator::Oauth::AuthenticationError, with: :authentication_oauth_error
    rescue_from UserAuthenticator::Standard::AuthenticationError, with: :authentication_standard_error

    rescue_from AuthorizationError, with: :authorization_error
    
    before_action :authorize!
    
    def authentication_oauth_error
        error = {
            "status"    => "401",
            "source"    => {"pointer" => "/code"},
            "title"     => "Authentication code is invalid",
            "details"   => "You must provide valid code in order to exchange it for token."
        }
        render json: {"error": [error]}, status: 401
    end

    def authentication_standard_error
        error = {
            "status"    => "401",
            "source"    => {"pointer" => "/data/attributes/password"},
            "title"     => "invalid username / password",
            "details"   => "You must provide valid credentials to exchange it for token."
        }
        render json: {"error": [error]}, status: 401
    end
    
    def authorization_error
        error = {
            "status"    => "403",
            "source"    => {"pointer" => "/headers/authorization"},
            "title"     => "Not authorized",
            "details"   => "You have no right to access this resource."
        }
        render json: { "errors": [ error ] }, status: 403
    end

    private
    
    def authorize!
        raise AuthorizationError unless current_user
    end
    
    def access_token
        provided_token  = request.authorization&.gsub(/\ABearer\s/,'')
        @access_token   = AccessToken.find_by(token: provided_token)
    end
    
    def current_user
        @current_user = access_token&.user
    end
end

