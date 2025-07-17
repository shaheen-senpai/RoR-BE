require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # GET /api/v1/users
  describe 'GET /api/v1/users' do
    let!(:users) { create_list(:user, 5) }
    let(:user) { users.first }
    
    context 'when authenticated' do
      before do
        get '/api/v1/users', headers: auth_headers(user)
      end
      
      it 'returns all users' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when not authenticated' do
      before do
        get '/api/v1/users'
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
  
  # GET /api/v1/users/:id
  describe 'GET /api/v1/users/:id' do
    let!(:user) { create(:user) }
    let(:user_id) { user.id }
    
    context 'when authenticated' do
      before do
        get "/api/v1/users/#{user_id}", headers: auth_headers(user)
      end
      
      context 'when the user exists' do
        it 'returns the user' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(user_id)
          expect(json['email']).to eq(user.email)
        end
        
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
      
      context 'when the user does not exist' do
        let(:user_id) { 999 }
        
        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
  
  # POST /api/v1/users
  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      { 
        user: {
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end
    
    context 'when the request is valid' do
      before do
        post '/api/v1/users', params: valid_attributes
      end
      
      it 'creates a user' do
        expect(json['user']['email']).to eq('new@example.com')
      end
      
      it 'returns a token' do
        expect(json).to have_key('token')
        expect(json['token']).to be_a(String)
      end
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when the request is invalid' do
      before do
        post '/api/v1/users', params: { 
          user: {
            email: 'invalid',
            password: 'pass'
          }
        }
      end
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns a validation failure message' do
        expect(json).to have_key('errors')
      end
    end
  end
  
  # PUT /api/v1/users/:id
  describe 'PUT /api/v1/users/:id' do
    let!(:user) { create(:user) }
    let(:valid_attributes) do
      { 
        user: {
          email: 'updated@example.com'
        }
      }
    end
    
    context 'when authenticated' do
      before do
        put "/api/v1/users/#{user.id}", 
            params: valid_attributes,
            headers: auth_headers(user)
      end
      
      it 'updates the user' do
        expect(json['email']).to eq('updated@example.com')
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
  
  # DELETE /api/v1/users/:id
  describe 'DELETE /api/v1/users/:id' do
    let!(:user) { create(:user) }
    
    context 'when authenticated' do
      before do
        delete "/api/v1/users/#{user.id}", headers: auth_headers(user)
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end
