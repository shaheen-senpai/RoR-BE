# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  it { should validate_presence_of(:email) }
  
  describe 'uniqueness validation' do
    subject { create(:user, email: 'test@example.com', password: 'password123') }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
  
  it { should have_secure_password }
  it { should validate_presence_of(:password) }
  
  # JWT token generation
  describe '#generate_jwt' do
    let(:user) { create(:user) }
    
    it 'generates a valid JWT token' do
      token = user.generate_jwt
      expect(token).to be_a(String)
      
      # Verify token can be decoded
      decoded_token = User.decode_jwt(token)
      expect(decoded_token).to be_a(Hash)
      expect(decoded_token['user_id']).to eq(user.id)
    end
  end
  
  # JWT token decoding
  describe '.decode_jwt' do
    let(:user) { create(:user) }
    
    it 'decodes a valid token' do
      token = user.generate_jwt
      decoded_token = User.decode_jwt(token)
      
      expect(decoded_token).to be_a(Hash)
      expect(decoded_token['user_id']).to eq(user.id)
    end
    
    it 'returns nil for an invalid token' do
      expect(User.decode_jwt('invalid_token')).to be_nil
    end
  end
end
