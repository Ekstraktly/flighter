RSpec.describe 'Flights Statistics API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /api/statistics/flights' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) do
        FactoryBot.create(:flight,
                          no_of_seats: 100,
                          base_price: 100)
      end

      before do
        FactoryBot.create(:booking,
                          user: user,
                          flight: flight,
                          no_of_seats: 50,
                          seat_price: 200)
        get '/api/statistics/flights', headers: { Authorization: user.token }
      end

      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns revenue' do
        expect(json_body[:flights].first).to include(revenue: 100_00)
      end
      it 'returns no_of_booked_seats' do
        expect(json_body[:flights].first).to include(no_of_booked_seats: 50)
      end
      it 'returns occupancy' do
        expect(json_body[:flights].first).to include(occupancy: '50.0%')
      end
    end
  end
end
