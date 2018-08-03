RSpec.describe 'Flights Statistics API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /api/statistics/flights' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create_list(:flight, 3)
        get '/api/statistics/flights', headers: { Authorization: user.token }
      end

      it 'successfully returns a list of flights' do
        expect(json_body[:flights].length).to eq(3)
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns revenue' do
        expect(json_body[:flights].first).to include(:revenue)
      end
      it 'returns revenue' do
        expect(json_body[:flights].first).to include(:no_of_booked_seats)
      end
      it 'returns revenue' do
        expect(json_body[:flights].first).to include(:occupancy)
      end
    end

    context 'when unauthenticated user and valid params' do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create_list(:flight, 3)
        get '/api/flights', headers: { Authorization: 'wrong_token' }
      end

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns token is invalid error' do
        expect(json_body[:errors][:token]).to eq(['is invalid'])
      end
    end
  end
end
