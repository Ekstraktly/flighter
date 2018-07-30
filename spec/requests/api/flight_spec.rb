RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /flights' do
    before do
      FactoryBot.create_list(:flight, 3)
      get '/api/flights'
    end

    it 'successfully returns a list of flights' do
      expect(json_body[:flights].length).to eq(3)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /flights/:id' do
    let(:flight) { FactoryBot.create(:flight) }

    before { get "/api/flights/#{flight.id}" }

    it 'returns a single flight' do
      expect(json_body[:flight]).to include(:name)
    end
    it 'returns stats OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/flights/' do
    let(:company) { FactoryBot.create(:company) }
    let(:flight_params) do
      FactoryBot.attributes_for(:flight)
                .merge(company_id: company.id.to_s)
    end

    context 'when params are valid' do
      it 'creates a flight' do
        expect do
          post '/api/flights', params: { flight: flight_params }
        end.to change(Flight, :count).by(1)
      end
      it 'checks for company_id' do
        post '/api/flights', params: { flight: flight_params }
        expect(json_body[:flight]).to include(company_id: company.id)
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/flights', params: { flight: { name: '' } }
        end.to change(Flight, :count).by(0)
      end
      it 'returns bad request' do
        post '/api/flights', params: { flight: { name: '' } }
        expect(response).to have_http_status(:bad_request)
      end
      it 'checks for errors key' do
        post '/api/flights', params: { flight: { name: '' } }
        expect(json_body[:errors]).to include(:name)
      end
    end
  end

  describe 'UPDATE /api/flights/:id' do
    let(:flights) { FactoryBot.create_list(:flight, 3) }

    before do
      put "/api/flights/#{flights.first.id}",
          params: { flight: { name: 'Afrika Airlines' } }
    end

    context 'when params are valid' do
      it 'updates a flight' do
        expect(json_body[:flight]).to include(name: 'Afrika Airlines')
      end
      it 'check existance of no_of_seats' do
        expect(json_body[:flight]).to include(:no_of_seats)
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /api/flights/:id' do
    let(:flight) { FactoryBot.create(:flight) }

    before { flight }

    context 'when params are valid' do
      it 'deletes a flight' do
        expect do
          delete "/api/flights/#{flight.id}"
        end.to change(Flight, :count).by(-1)
      end
      it 'shows 204 Bad request' do
        delete "/api/flights/#{flight.id}"
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
