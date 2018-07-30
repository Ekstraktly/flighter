RSpec.describe 'Users API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /users' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        get '/api/users', headers: { Authorization: user.token }
      end

      it 'successfully returns a list of users' do
        expect(json_body[:users].length).to eq(1)
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        get '/api/users', headers: { Authorization: 'wrong_token' }
      end

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns token is invalid error' do
        expect(json_body[:errors][:token]).to eq(['is invalid'])
      end
    end
  end

  describe 'GET /users/:id' do
    let(:user) { FactoryBot.create(:user) }

    before do
      get "/api/users/#{user.id}",
          headers: { Authorization: user.token }
    end

    it 'returns a single user' do
      expect(json_body[:user]).to include(:email)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end

    context 'when user is unauthenticated' do
      before do
        get '/api/users/wrong_user',
            headers: { Authorization: user.token }
      end

      it 'returns stauts 400 Bad request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      before do
        get "/api/users/#{user2.id}",
            headers: { Authorization: user.token }
      end

      it 'returns status 403 Forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
      it 'returns token is invalid error' do
        expect(json_body[:errors][:resource]).to eq(['is forbidden'])
      end
    end
  end

  describe 'POST /api/users/' do
    context 'when params are valid' do
      let(:user_params) { FactoryBot.attributes_for(:user) }

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
    let(:user) { FactoryBot.create(:user) }

    context 'when authenticated user' do
      before do
        put "/api/users/#{user.id}",
            params: { user: { email: 'ivan.novak@mail.hr',
                              password: 'password' } },
            headers: { Authorization: user.token }
      end

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

    context 'when params are invalid' do
      before do
        put "/api/users/#{user.id}",
            params: { user: { email: 'joso@meso.hr',
                              password: nil } },
            headers: { Authorization: user.token }
      end

      it 'returns 400 Bad request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when unauthenticated user' do
      before do
        put "/api/users/#{user.id}",
            params: { user: { email: 'ivan.novak@mail.hr',
                              password: 'password' } },
            headers: { Authorization: 'wrong_token' }
      end

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns token is invalid error' do
        expect(json_body[:errors][:token]).to eq(['is invalid'])
      end
    end

    context 'when user is authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      before { user2 }

      it 'returns status Forbidden' do
        put "/api/users/#{user2.id}",
            params: { user: { email: 'ivan.novak@mail.hr',
                              password: 'password' } },
            headers: { Authorization: user.token }
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns errors' do
        put "/api/users/#{user2.id}",
            params: { user: { email: 'ivan.novak@mail.hr',
                              password: 'password' } },
            headers: { Authorization: user.token }
        expect(json_body[:errors]).to include(:resource)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let(:user) { FactoryBot.create(:user) }

    before { user }

    it 'deletes a user' do
      expect do
        delete "/api/users/#{user.id}",
               headers: { Authorization: user.token }
      end.to change(User, :count).by(-1)
    end
    it 'returns 204 No content' do
      delete "/api/users/#{user.id}",
             headers: { Authorization: user.token }
      expect(response).to have_http_status(:no_content)
    end

    context 'when user is unauthenticated' do
      let(:user) { FactoryBot.create(:user) }

      before { user }

      it "doesn't delete user" do
        delete "/api/users/#{user.id}",
               headers: { Authorization: 'wrong_token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated but unauthorized' do
      let(:user2) { FactoryBot.create(:user) }

      it 'returns status Forbidden' do
        delete "/api/users/#{user2.id}",
               headers: { Authorization: user.token }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
