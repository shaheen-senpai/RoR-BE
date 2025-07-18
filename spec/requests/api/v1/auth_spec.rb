require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  # Login endpoint
  path '/api/v1/auth/login' do
    post 'Authenticates user and returns token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'user authenticated' do
        let!(:test_user) { create(:user, email: 'test@example.com', password: 'password123') }
        let(:user) { { email: 'test@example.com', password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
          expect(data).to have_key('user')
          expect(data['user']['email']).to eq('test@example.com')
        end
      end

      response '401', 'invalid credentials' do
        let(:user) { { email: 'test@example.com', password: 'wrong_password' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Invalid email or password')
        end
      end
    end
  end

  # Logout endpoint
  path '/api/v1/auth/logout' do
    delete 'Logs out user by invalidating token' do
      tags 'Authentication'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'logged out successfully' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('message')
          expect(data['message']).to eq('Logged out successfully')
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end

  # Helper method to generate token for testing
  def generate_token_for(user)
    user.generate_jwt
  end
end
