require 'rails_helper'

RSpec.describe 'Features API', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/features' do
    context 'when authenticated' do
      before do
        # Setup some feature flags for testing
        Flipper.enable(:api_rate_limiting)
        Flipper.enable(:premium_features, user)
        
        get '/api/v1/features', headers: auth_headers(user)
      end
      
      it 'returns a list of feature flags and their status' do
        expect(response).to have_http_status(200)
        expect(json).to have_key('features')
        expect(json['features']).to include('premium_features', 'api_rate_limiting', 'new_dashboard')
      end
      
      it 'correctly shows enabled features for the user' do
        expect(json['features']['premium_features']).to be true
        expect(json['features']['api_rate_limiting']).to be true
      end
    end
    
    context 'when not authenticated' do
      before do
        get '/api/v1/features'
      end
      
      it 'returns unauthorized error' do
        expect(response).to have_http_status(401)
        expect(json).to have_key('error')
        expect(json['error']).to eq('Unauthorized')
      end
    end
  end
  
  describe 'GET /api/v1/features/:id' do
    context 'when authenticated' do
      before do
        Flipper.enable(:premium_features, user)
        get '/api/v1/features/premium_features', headers: auth_headers(user)
      end
      
      it 'returns the status of a specific feature flag' do
        expect(response).to have_http_status(200)
        expect(json).to have_key('feature')
        expect(json).to have_key('enabled')
        expect(json['feature']).to eq('premium_features')
        expect(json['enabled']).to be true
      end
    end
    
    context 'when the feature is disabled' do
      before do
        Flipper.disable(:premium_features, user)
        get '/api/v1/features/premium_features', headers: auth_headers(user)
      end
      
      it 'returns false for disabled features' do
        expect(response).to have_http_status(200)
        expect(json['enabled']).to be false
      end
    end
  end
end
