RSpec.describe 'Flights Query API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /api/flights' do
    let(:user) { FactoryBot.create(:user) }

    context 'when calculating current_price after flight has departed' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: Time.zone.now,
                          base_price: 10)
      end

      before do
        get "/api/flights/#{flight.id}", headers: { Authorization: user.token }
      end

      it 'returns double price' do
        expect(json_body[:flight]).to include(current_price: 20)
      end
    end

    context 'when calculating current price more than two w before flight' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: Time.zone.now + 15.days,
                          lands_at: Time.zone.now + 16.days,
                          base_price: 10)
      end

      before do
        get "/api/flights/#{flight.id}", headers: { Authorization: user.token }
      end

      it 'returns base price' do
        expect(json_body[:flight]).to include(current_price: 10)
      end
    end
  end
end
