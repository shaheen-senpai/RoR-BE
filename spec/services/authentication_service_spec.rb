require 'rails_helper'

RSpec.describe AuthenticationService do
  describe '.authenticate' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }
    
    context 'with valid credentials' do
      it 'returns success with user and token' do
        result = described_class.authenticate('test@example.com', 'password123')
        
        expect(result[:success]).to be true
        expect(result[:user]).to eq(user)
        expect(result[:token]).to be_present
      end
    end
    
    context 'with invalid email' do
      it 'returns failure with error message' do
        result = described_class.authenticate('wrong@example.com', 'password123')
        
        expect(result[:success]).to be false
        expect(result[:errors]).to include('Invalid email or password')
      end
    end
    
    context 'with invalid password' do
      it 'returns failure with error message' do
        result = described_class.authenticate('test@example.com', 'wrongpassword')
        
        expect(result[:success]).to be false
        expect(result[:errors]).to include('Invalid email or password')
      end
    end
  end
end
