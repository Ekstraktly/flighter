RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /users' do
    before do
      FactoryBot.create_list(:user, 3)
      get '/api/users'
    end

    it 'successfully returns a list of users' do
      expect(json_body[:users].length).to eq(3)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    before { get "/api/users/#{user.id}" }

    it 'returns a single user' do
      expect(json_body[:user]).to include(:email)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/users/' do
    let(:user_params) { FactoryBot.attributes_for(:user) }

    context 'when params are valid' do
      it 'creates a user' do
        expect do
          post '/api/users', params: { user: user_params }
        end.to change(User, :count).by(1)
      end
      it 'checks email attribute' do
        post '/api/users', params: { user: user_params }
        expect(json_body[:user]).to include(email: user_params[:email])
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/users', params: { user: { email: '' } }
        end.to change(User, :count).by(0)
      end
      it 'returns bad request' do
        post '/api/users', params: { user: { email: '' } }
        expect(response).to have_http_status(:bad_request)
      end
      it 'checks for errors key' do
        post '/api/users', params: { user: { email: '' } }
        expect(json_body[:errors]).to include(:email)
      end
    end
  end

  describe 'UPDATE /api/users/:id' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    before do
      put "/api/users/#{users.first.id}",
          params: { user: { email: 'ivan.novak@mail.hr' } }
    end

    context 'when params are valid' do
      it 'updates a user' do
        expect(json_body[:user]).to include(email: 'ivan.novak@mail.hr')
      end
      it 'contains first_name' do
        expect(json_body[:user]).to include(:first_name)
      end
      it 'responds with OK' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let(:user) { FactoryBot.create(:user) }

    before { user }

    context 'when params are valid' do
      it 'deletes a user' do
        expect do
          delete "/api/users/#{user.id}"
        end.to change(User, :count).by(-1)
      end
      it 'returns 204 No content' do
        delete "/api/users/#{user.id}"
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
