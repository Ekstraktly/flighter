RSpec.describe 'Users API', type: :request do
  # include TestHelpers::JsonResponse
  describe 'GET /users' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    it 'successfully returns a list of users' do
      get '/api/users'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    it 'returns a single user' do
      get "/api/users/#{users.first.id}"
      json_body = JSON.parse(response.body)
      expect(json_body).to include('email')
    end
  end

  describe 'POST /api/users/:id' do
    context 'when params are valid' do
      it 'creates a user' do
        post '/api/users',
             params: { user: { email: 'darko@marko.com',
                               first_name: 'Darko',
                               last_name: 'Marko' } }
        json_body = JSON.parse(response.body)
        expect(json_body).to include('email' => 'darko@marko.com')
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        post '/api/users', params: { user: { email: '' } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
