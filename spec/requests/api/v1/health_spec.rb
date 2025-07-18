require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Health API', type: :request do
  path '/api/v1/health' do
    get 'Retrieves API health status' do
      tags 'Health'
      produces 'application/json'

      response '200', 'health status retrieved' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('status')
          expect(data).to have_key('timestamp')
          expect(data).to have_key('environment')
          expect(data).to have_key('database')
          expect(data).to have_key('redis')
          expect(data['status']).to eq('ok')
          expect(data['environment']).to eq('test')
        end
      end
    end
  end
end
