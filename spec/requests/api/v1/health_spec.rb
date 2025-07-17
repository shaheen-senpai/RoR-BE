require 'rails_helper'

RSpec.describe 'Health API', type: :request do
  describe 'GET /api/v1/health' do
    before do
      get '/api/v1/health'
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    
    it 'returns health information' do
      expect(json).to have_key('status')
      expect(json).to have_key('version')
      expect(json).to have_key('timestamp')
      expect(json).to have_key('environment')
      expect(json).to have_key('database')
      expect(json).to have_key('redis')
    end
    
    it 'indicates the API is operational' do
      expect(json['status']).to eq('ok')
    end
    
    it 'shows the correct environment' do
      expect(json['environment']).to eq('test')
    end
  end
end
