require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  # Helper method to generate token for testing
  def generate_token_for(user)
    user.generate_jwt
  end

  # GET /api/v1/users
  path '/api/v1/users' do
    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'users found' do
        let!(:users) { create_list(:user, 5) }
        let(:user) { users.first }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
          expect(data['users']).not_to be_empty
          expect(data['users'].size).to eq(5)
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end

  # GET /api/v1/users/:id
  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'User ID'

    get 'Retrieves a specific user' do
      tags 'Users'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'user found' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
          expect(data['id']).to eq(user.id)
          expect(data['email']).to eq(user.email)
        end
      end

      response '404', 'user not found' do
        let!(:user) { create(:user) }
        let(:id) { 999 }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test! do |response|
          expect(response).to have_http_status(404)
        end
      end

      response '401', 'unauthorized' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end

  # POST /api/v1/users
  path '/api/v1/users' do
    post 'Creates a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'new@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        let(:user_params) do
          {
            user: {
              email: 'new@example.com',
              password: 'password123',
              password_confirmation: 'password123'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['user']['email']).to eq('new@example.com')
          expect(data).to have_key('token')
          expect(data['token']).to be_a(String)
        end
      end

      response '422', 'invalid request' do
        let(:user_params) do
          {
            user: {
              email: 'invalid',
              password: 'pass'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('errors')
        end
      end
    end
  end

  # PUT /api/v1/users/:id
  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'User ID'

    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'updated@example.com' }
            }
          }
        },
        required: ['user']
      }

      response '200', 'user updated' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:user_params) do
          {
            user: {
              email: 'updated@example.com'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to eq('updated@example.com')
        end
      end

      response '401', 'unauthorized' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { nil }
        let(:user_params) do
          {
            user: {
              email: 'updated@example.com'
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end

  # DELETE /api/v1/users/:id
  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'User ID'

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '204', 'user deleted' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test!
      end

      response '401', 'unauthorized' do
        let!(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end
end
