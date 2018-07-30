RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /bookings' do
    let(:test_flight) { FactoryBot.create(:flight) }
    let(:test_user) { FactoryBot.create(:user) }

    before do
      Booking.create(flight: test_flight,
                     user: test_user,
                     no_of_seats: 2,
                     seat_price: 100)
      get '/api/bookings'
    end

    it 'successfully returns a list of bookings' do
      expect(json_body[:bookings].length).to eq(1)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /bookings/:id' do
    let(:test_flight) { FactoryBot.create(:flight) }
    let(:test_user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: test_flight,
                     user: test_user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    before { get "/api/bookings/#{booking.id}" }

    it 'returns a single booking' do
      expect(json_body[:booking]).to include(:seat_price)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/bookings/' do
    let(:test_flight) { FactoryBot.create(:flight) }
    let(:test_user) { FactoryBot.create(:user) }
    let(:booking_params) do
      { flight_id: test_flight.id.to_s,
        user_id: test_user.id.to_s,
        no_of_seats: '2',
        seat_price: '200' }
    end

    context 'when params are valid' do
      it 'creates a booking' do
        expect do
          post '/api/bookings', params: { booking: booking_params }
        end.to change(Booking, :count).by(1)
      end
      it 'checks existance of seat_price' do
        post '/api/bookings', params: { booking: booking_params }
        expect(json_body[:booking]).to include(seat_price: 200)
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/bookings', params: { booking: { flight_id: '' } }
        end.to change(User, :count).by(0)
      end
      it 'returns errors' do
        post '/api/bookings', params: { booking: { flight_id: '' } }
        expect(json_body[:errors]).to include(:flight)
      end
      it 'returns status 204 Bad request' do
        post '/api/bookings', params: { booking: { flight_id: '' } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'UPDATE /api/bookings/:id' do
    let(:test_flight) { FactoryBot.create(:flight) }
    let(:test_user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: test_flight,
                     user: test_user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    before do
      put "/api/bookings/#{booking.id}",
          params: { booking: { no_of_seats: 3 } }
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

  describe 'DELETE /api/bookings/:id' do
    let(:test_flight) { FactoryBot.create(:flight) }
    let(:test_user) { FactoryBot.create(:user) }
    let(:booking) do
      Booking.create(flight: test_flight,
                     user: test_user,
                     no_of_seats: 2,
                     seat_price: 100)
    end

    before { booking }

    context 'when params are valid' do
      it 'deletes a booking' do
        expect do
          delete "/api/bookings/#{booking.id}"
        end.to change(Booking, :count).by(-1)
      end
      it 'returns 204 Bad request' do
        delete "/api/bookings/#{booking.id}"
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
