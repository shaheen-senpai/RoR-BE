module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:login]
      
      # POST /api/v1/auth/login
      def login
        # Handle both direct parameters and nested parameters
        email = params[:user].present? ? params[:user][:email] : params[:email]
        password = params[:user].present? ? params[:user][:password] : params[:password]
        
        result = AuthenticationService.authenticate(email, password)
        
        if result[:success]
          render json: { 
            token: result[:token], 
            user: UserSerializer.new(result[:user]) 
          }, status: :ok
        else
          render json: { error: result[:errors].first }, status: :unauthorized
        end
      end
      
      # DELETE /api/v1/auth/logout
      def logout
        # In a stateless JWT setup, the client simply discards the token
        # For added security, we could implement token blacklisting using Redis
        token = request.headers['Authorization']&.split(' ')&.last
        
        if token.present?
          # Uncomment to enable token blacklisting
          # $redis.setex("blacklist:#{token}", 24.hours.to_i, true)
        end
        
        render json: { message: 'Logged out successfully' }, status: :ok
      end
    end
  end
end
