class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ErrorHandler
  
  before_action :authenticate_user!
  
  private
  
  # Authenticate user from JWT token in Authorization header
  def authenticate_user!
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  
  # Get current user from JWT token
  def current_user
    @current_user ||= begin
      token = request.headers['Authorization']&.split(' ')&.last
      return nil unless token
      
      payload = User.decode_jwt(token)
      return nil unless payload
      
      # Check if token is blacklisted (optional)
      # return nil if $redis.exists?("blacklist:#{token}")
      
      User.find_by(id: payload['user_id'])
    end
  end
end
