require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Features API', type: :request do
  # Helper method to generate token for testing
  def generate_token_for(user)
    user.generate_jwt
  end

  path '/api/v1/features' do
    get 'Retrieves all feature flags' do
      tags 'Features'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'feature flags retrieved' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        before do
          # Setup some feature flags for testing
          Flipper.enable(:api_rate_limiting)
          Flipper.enable(:premium_features, user)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('features')
          expect(data['features']).to include('premium_features', 'api_rate_limiting', 'new_dashboard')
          expect(data['features']['premium_features']).to be true
          expect(data['features']['api_rate_limiting']).to be true
        end
      end

      response '401', 'unauthorized' do
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(401)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end

  path '/api/v1/features/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'Feature flag name'

    get 'Retrieves a specific feature flag status' do
      tags 'Features'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'feature flag status retrieved' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:id) { 'premium_features' }

        before do
          Flipper.enable(:premium_features, user)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('feature')
          expect(data).to have_key('enabled')
          expect(data['feature']).to eq('premium_features')
          expect(data['enabled']).to be true
        end
      end

      response '200', 'feature flag is disabled' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:id) { 'premium_features' }

        before do
          Flipper.disable(:premium_features, user)
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(200)
          expect(data['enabled']).to be false
        end
      end

      response '401', 'unauthorized' do
        let(:id) { 'premium_features' }
        let(:Authorization) { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response).to have_http_status(401)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Unauthorized')
        end
      end
    end
  end
end
