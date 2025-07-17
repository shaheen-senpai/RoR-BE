module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  # Generate valid JWT token for a user
  def token_for_user(user)
    user.generate_jwt
  end

  # Set Authorization header with JWT token
  def auth_headers(user)
    { 'Authorization' => "Bearer #{token_for_user(user)}" }
  end
end
