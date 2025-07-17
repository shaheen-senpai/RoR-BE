require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do
  # Login endpoint
  describe 'POST /api/v1/auth/login' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
    
    context 'with valid credentials' do
      before do
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'password123' }
      end
      
      it 'returns a token' do
        expect(json).to have_key('token')
        expect(json['token']).to be_a(String)
      end
      
      it 'returns user information' do
        expect(json).to have_key('user')
        expect(json['user']).to have_key('id')
        expect(json['user']['email']).to eq('test@example.com')
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'with invalid credentials' do
      before do
        post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'wrong_password' }
      end
      
      it 'returns an error message' do
        expect(json).to have_key('error')
        expect(json['error']).to eq('Invalid email or password')
      end
      
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
  
  # Logout endpoint
  describe 'DELETE /api/v1/auth/logout' do
    let(:user) { create(:user) }
    
    context 'when authenticated' do
      before do
        delete '/api/v1/auth/logout', headers: auth_headers(user)
      end
      
      it 'returns success message' do
        expect(json).to have_key('message')
        expect(json['message']).to eq('Logged out successfully')
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when not authenticated' do
      before do
        delete '/api/v1/auth/logout'
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
