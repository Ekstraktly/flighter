RSpec.describe 'Companys Statistics API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET api/statistics/companies' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }
      let(:other_flight) { FactoryBot.create(:flight) }

      before do
        FactoryBot.create(:booking, user: user, flight: flight)
        FactoryBot.create(:booking, user: user, flight: other_flight)
        get '/api/statistics/companies', headers: { Authorization: user.token }
      end

      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns total revenue' do
        expect(json_body[:companies].first).to include(total_revenue: 300)
      end

      it 'returns total number of booked seats' do
        expect(json_body[:companies].first)
          .to include(total_no_of_booked_seats: 3)
      end
    end

    context 'when unauthenticated user' do
      let(:user) { FactoryBot.create(:user) }

      before do
        get '/api/companies', headers: { Authorization: 'wrong_token' }
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
