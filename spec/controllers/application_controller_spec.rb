require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Create a test controller that inherits from ApplicationController
  controller do
    def index
      render json: { user_id: current_user.id }
    end
  end

  let(:user) { create(:user) }
  let(:token) { user.generate_jwt }

  describe '#authenticate_user!' do
    context 'when a valid token is provided' do
      before do
        request.headers['Authorization'] = "Bearer #{token}"
        routes.draw { get 'index' => 'anonymous#index' }
        get :index
      end

      it 'allows the request' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets the current_user' do
        expect(JSON.parse(response.body)['user_id']).to eq(user.id)
      end
    end

    context 'when no token is provided' do
      before do
        routes.draw { get 'index' => 'anonymous#index' }
        get :index
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end

    context 'when an invalid token is provided' do
      before do
        request.headers['Authorization'] = 'Bearer invalid_token'
        routes.draw { get 'index' => 'anonymous#index' }
        get :index
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
