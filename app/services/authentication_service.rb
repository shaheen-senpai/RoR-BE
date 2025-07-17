class AuthenticationService
  attr_reader :email, :password, :errors

  def initialize(email, password)
    @email = email
    @password = password
    @errors = []
  end

  def authenticate
    user = User.find_by(email: email)
    
    if user&.authenticate(password)
      return { success: true, user: user, token: user.generate_jwt }
    else
      @errors << "Invalid email or password"
      return { success: false, errors: @errors }
    end
  end

  def self.authenticate(email, password)
    new(email, password).authenticate
  end
end
