require 'rails_helper'

RSpec.describe 'Dashboard API', type: :request do
  # GET /api/v1/dashboard
  describe 'GET /api/v1/dashboard' do
    let(:user) { create(:user) }
    
    context 'when authenticated' do
      before do
        get '/api/v1/dashboard', headers: auth_headers(user)
      end
      
      it 'returns dashboard information' do
        expect(json).not_to be_empty
        expect(json).to have_key('message')
        expect(json).to have_key('user_id')
        expect(json).to have_key('timestamp')
        expect(json['user_id']).to eq(user.id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when not authenticated' do
      before do
        get '/api/v1/dashboard'
      end
      
      it 'returns unauthorized error' do
        expect(json).to have_key('error')
        expect(json['error']).to eq('Unauthorized')
      end
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
