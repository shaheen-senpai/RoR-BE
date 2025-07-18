require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Dashboard API', type: :request do
  # Helper method to generate token for testing
  def generate_token_for(user)
    user.generate_jwt
  end

  # GET /api/v1/dashboard
  path '/api/v1/dashboard' do
    get 'Retrieves dashboard information' do
      tags 'Dashboard'
      produces 'application/json'
      security [{ bearer_auth: [] }]

      response '200', 'dashboard information retrieved' do
        let(:user) { create(:user) }
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
          expect(data).to have_key('message')
          expect(data).to have_key('user_id')
          expect(data).to have_key('timestamp')
          expect(data['user_id']).to eq(user.id)
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
end
