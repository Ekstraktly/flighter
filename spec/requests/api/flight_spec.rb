RSpec.describe 'Flights API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /flights' do
    context 'when authenticated user' do
      context 'when params are valid' do
        let(:user) { FactoryBot.create(:user) }

        before do
          FactoryBot.create_list(:flight, 3)
          get '/api/flights', headers: { Authorization: user.token }
        end

        it 'successfully returns a list of flights' do
          expect(json_body[:flights].length).to eq(3)
        end
        it 'returns status OK' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when unauthenticated user' do
      context 'when params are valid' do
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

  describe 'GET /flights/:id' do
    context 'when authenticated user' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }

      context 'when params are valid' do
        before do
          get "/api/flights/#{flight.id}",
              headers: { Authorization: user.token }
        end

        it 'returns a single flight' do
          expect(json_body[:flight]).to include(:name)
        end
        it 'returns stats OK' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when params are invalid' do
        before do
          get '/api/flights/wrong_flight',
              headers: { Authorization: user.token }
        end

        it 'returns stauts 400 Bad request shoud return)' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when unauthenticated user' do
      context 'when params are valid' do
        let(:user) { FactoryBot.create(:user) }
        let(:flight) { FactoryBot.create(:flight) }

        before do
          get "/api/flights/#{flight.id}",
              headers: { Authorization: 'wrong_token' }
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

  describe 'POST /api/flights/' do
    let(:user) { FactoryBot.create(:user) }
    let(:company) { FactoryBot.create(:company) }
    let(:flight_params) do
      FactoryBot.attributes_for(:flight)
                .merge(company_id: company.id.to_s)
    end

    context 'when params are valid' do
      it 'creates a flight' do
        expect do
          post '/api/flights', params: { flight: flight_params },
                               headers: { Authorization: user.token }
        end.to change(Flight, :count).by(1)
      end
      it 'checks for company_id' do
        post '/api/flights', params: { flight: flight_params },
                             headers: { Authorization: user.token }
        expect(json_body[:flight]).to include(company_id: company.id)
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/flights', params: { flight: { name: '' } },
                               headers: { Authorization: user.token }
        end.to change(Flight, :count).by(0)
      end
      it 'returns bad request' do
        post '/api/flights', params: { flight: { name: '' } },
                             headers: { Authorization: user.token }
        expect(response).to have_http_status(:bad_request)
      end
      it 'checks for errors key' do
        post '/api/flights', params: { flight: { name: '' } },
                             headers: { Authorization: user.token }
        expect(json_body[:errors]).to include(:name)
      end
    end
  end

  describe 'UPDATE /api/flights/:id' do
    context 'when authenticated user' do
      let(:user) { FactoryBot.create(:user) }
      let(:flights) { FactoryBot.create_list(:flight, 3) }

      context 'when params are valid' do
        before do
          put "/api/flights/#{flights.first.id}",
              params: { flight: { name: 'Afrika Airlines' } },
              headers: { Authorization: user.token }
        end

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

      context 'when params are invalid' do
        before do
          put "/api/flights/#{flights.first.id}",
              params: { flight: { name: '' } },
              headers: { Authorization: user.token }
        end

        it 'returns 400 Bad request' do
          expect(response).to have_http_status(:bad_request)
        end
        it 'does not update a flight name' do
          expect(json_body[:errors]).to include(:name)
        end
      end
    end

    context 'when unauthenticated user' do
      let(:user) { FactoryBot.create(:user) }
      let(:flights) { FactoryBot.create_list(:flight, 3) }

      context 'when params are valid' do
        before do
          put "/api/flights/#{flights.first.id}",
              params: { flight: { name: 'Afrika Airlines' } },
              headers: { Authorization: 'wrong_token' }
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

  describe 'DELETE /api/flights/:id' do
    context 'when user is authenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }

      before do
        user
        flight
      end

      context 'when params are valid' do
        it 'deletes a flight' do
          expect do
            delete "/api/flights/#{flight.id}",
                   headers: { Authorization: user.token }
          end.to change(Flight, :count).by(-1)
        end
        it 'shows 204 Bad request' do
          delete "/api/flights/#{flight.id}",
                 headers: { Authorization: user.token }
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when params are invalid' do
        it 'does not delete flight' do
          expect do
            delete '/api/flights/wrong_flight',
                   headers: { Authorization: user.token }
          end.to change(Flight, :count).by(0)
        end
        it 'returns status Bad request' do
          delete '/api/users/wrong_user',
                 headers: { Authorization: user.token }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when user is unauthenticated' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }

      before do
        user
        flight
      end

      it 'returns status Unauthorized' do
        delete "/api/flights/#{flight.id}",
               headers: { Authorization: 'wrong_token' }
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does not delete flight' do
        expect do
          delete "/api/flights/#{flight.id}",
                 headers: { Authorization: 'wrong_token' }
        end.to change(Flight, :count).by(0)
      end
    end
  end
end
