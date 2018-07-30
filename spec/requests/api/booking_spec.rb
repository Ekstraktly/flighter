RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /bookings' do
    context 'when authenticated user' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }

      before do
        Booking.create(flight: flight,
                       user: user,
                       no_of_seats: 2,
                       seat_price: 100)
        get '/api/bookings', headers: { Authorization: user.token }
      end

      context 'when params are valid' do
        it 'successfully returns a list of bookings' do
          expect(json_body[:bookings].length).to eq(1)
        end
        it 'returns status OK' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when unauthenticated user' do
      let(:user) { FactoryBot.create(:user) }
      let(:flight) { FactoryBot.create(:flight) }

      context 'when params are valid' do
        before do
          Booking.create(flight: flight,
                         user: user,
                         no_of_seats: 2,
                         seat_price: 100)
          get '/api/bookings', headers: { Authorization: 'wrong_token' }
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

  describe 'GET /bookings/:id' do
    let(:flight) { FactoryBot.create(:flight) }
    let(:user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: flight,
                     user: user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    context 'when authenticated user' do
      context 'when params are valid' do
        before do
          get "/api/bookings/#{booking.id}",
              headers: { Authorization: user.token }
        end

        it 'returns a single booking' do
          expect(json_body[:booking]).to include(:seat_price)
        end
        it 'returns status OK' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when params are invalid' do
        before do
          get '/api/bookings/wrong_id',
              headers: { Authorization: user.token }
        end

        it 'returns stauts 400 Bad request)' do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when unauthorized user' do
      context 'when params are valid' do
        before do
          get "/api/bookings/#{booking.id}",
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

  describe 'POST /api/bookings/' do
    let(:flight) { FactoryBot.create(:flight) }
    let(:user) { FactoryBot.create(:user) }
    let(:booking_params) do
      { flight_id: flight.id.to_s,
        user_id: user.id.to_s,
        no_of_seats: 2,
        seat_price: 200 }
    end

    context 'when params are valid' do
      it 'creates a booking' do
        expect do
          post '/api/bookings', params: { booking: booking_params },
                                headers: { Authorization: user.token }
        end.to change(user.bookings, :count).by(1)
      end
      it 'checks existance of seat_price' do
        post '/api/bookings', params: { booking: booking_params },
                              headers: { Authorization: user.token }
        expect(json_body[:booking]).to include(seat_price: 200)
      end
    end

    context 'when params are invalid' do
      it 'not change booking count' do
        expect do
          post '/api/bookings', params: { booking: { flight_id: '' } },
                                headers: { Authorization: user.token }
        end.to change(Booking, :count).by(0)
      end
      it 'returns status Bad request' do
        post '/api/bookings', params: { booking: { flight_id: '' } },
                              headers: { Authorization: user.token }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'UPDATE /api/bookings/:id' do
    let(:flight) { FactoryBot.create(:flight) }
    let(:user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: flight,
                     user: user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    context 'when user is authenticated' do
      before do
        put "/api/bookings/#{booking.id}",
            params: { booking: { no_of_seats: 3 } },
            headers: { Authorization: user.token }
      end

      context 'when params are valid' do
        it 'updates a booking' do
          expect(json_body[:booking]).to include(no_of_seats: 3)
        end
        it 'checks existance of flight_id attribute' do
          expect(json_body[:booking]).to include(:flight_id)
        end
        it 'returns status OK' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'when user is unauthenticated' do
      context 'when params are valid' do
        before do
          put "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: 3 } },
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

  describe 'DELETE /api/bookings/:id' do
    let(:flight) { FactoryBot.create(:flight) }
    let(:user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: flight,
                     user: user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    context 'when user is authenticated' do
      before { booking }

      context 'when params are valid' do
        it 'deletes a booking' do
          expect do
            delete "/api/bookings/#{booking.id}",
                   headers: { Authorization: user.token }
          end.to change(Booking, :count).by(-1)
        end
        it 'returns status No content' do
          delete "/api/bookings/#{booking.id}",
                 headers: { Authorization: user.token }
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when params are invalid' do
        it 'does not delete booking' do
          expect do
            delete '/api/bookings/wrong_booking',
                   headers: { Authorization: user.token }
          end.to change(Booking, :count).by(0)
        end
        it 'returns status Bad request' do
          delete '/api/users/wrong_user',
                 headers: { Authorization: user.token }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when user is unauthenticated' do
      before { booking }

      it 'returns status Unauthorized' do
        delete "/api/bookings/#{booking.id}",
               headers: { Authorization: 'wrong_token' }
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does not delete booking' do
        expect do
          delete "/api/bookings/#{booking.id}",
                 headers: { Authorization: 'wrong_token' }
        end.to change(Flight, :count).by(0)
      end
    end
  end
end
