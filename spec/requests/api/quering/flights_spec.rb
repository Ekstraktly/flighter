RSpec.describe 'Flights Query API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /api/flights' do
    let(:user) { FactoryBot.create(:user) }

    context 'when flight has departed' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: Time.zone.now,
                          base_price: 10)
      end

      before do
        get "/api/flights/#{flight.id}", headers: { Authorization: user.token }
      end

      it 'returns base price' do
        expect(json_body[:flight]).to include(base_price: 10)
      end
    end
  end

  describe 'POST /api/flights/' do
    let(:user) { FactoryBot.create(:user) }
    let(:company) { FactoryBot.create(:company) }

    context 'when flights are overlapping' do
      let(:flight_params) do
        FactoryBot.attributes_for(:flight,
                                  flys_at: Time.zone.now + 15.days,
                                  lands_at: Time.zone.now + 16.days)
                  .merge(company_id: company.id)
      end

      before do
        FactoryBot.create(:flight,
                          company_id: company.id,
                          flys_at: Time.zone.now + 15.days,
                          lands_at: Time.zone.now + 16.days)
      end

      it 'does not create a flight' do
        expect do
          post '/api/flights', params: { flight: flight_params },
                               headers: { Authorization: user.token }
        end.to change(Flight, :count).by(0)
      end
    end

    context 'when flights are not overlapping' do
      let(:flight_params) do
        FactoryBot.attributes_for(:flight,
                                  flys_at: Time.zone.now + 15.days,
                                  lands_at: Time.zone.now + 16.days)
                  .merge(company_id: company.id)
      end

      before do
        FactoryBot.create(:flight,
                          company_id: company.id,
                          flys_at: Time.zone.now + 18.days,
                          lands_at: Time.zone.now + 19.days)
      end

      it 'creates a flight' do
        expect do
          post '/api/flights', params: { flight: flight_params },
                               headers: { Authorization: user.token }
        end.to change(Flight, :count).by(1)
      end
    end
  end
end
