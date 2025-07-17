require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialization) { JSON.parse(serializer.to_json) }

  it 'includes the expected attributes' do
    expect(serialization.keys).to match_array(['id', 'email', 'created_at', 'updated_at'])
  end

  it 'serializes the id' do
    expect(serialization['id']).to eq(user.id)
  end

  it 'serializes the email' do
    expect(serialization['email']).to eq(user.email)
  end

  it 'serializes timestamps' do
    expect(serialization).to have_key('created_at')
    expect(serialization).to have_key('updated_at')
  end
end
