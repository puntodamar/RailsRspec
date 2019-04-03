class ApplicationController < ActionController::API
    
    rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
    
    def authentication_error
        error = {
            "status"    => "401",
            "source"    => {"pointer" => "/code"},
            "title"     => "Authentication code is invalid",
            "details"   => "You must provide valid code in order to exchange it for token."
        }
        render json: {"error": [error]}, status: 401
    end
end
