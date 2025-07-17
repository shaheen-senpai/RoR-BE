# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  # Paper Trail for auditing changes
  has_paper_trail
  
  # Methods
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  
  # JWT token generation
  def generate_jwt
    payload = {
      user_id: id,
      email: email,
      exp: 24.hours.from_now.to_i
    }
    
    JWT.encode(payload, ENV['JWT_SECRET_KEY'] || 'default_secret_key_for_development')
  end
  
  # Class methods for JWT token handling
  class << self
    def decode_jwt(token)
      begin
        JWT.decode(token, ENV['JWT_SECRET_KEY'] || 'default_secret_key_for_development')[0]
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
