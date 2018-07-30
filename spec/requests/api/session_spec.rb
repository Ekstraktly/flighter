RSpec.describe 'Sessions API', type: :request do
  include TestHelpers::JsonResponse

  describe 'POST /api/sessions/' do
    context 'when params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        post '/api/session', params: { session: { email: user.email,
                                                  password: user.password } }
      end

      it 'status is 201 created' do
        expect(response).to have_http_status(:created)
      end
      it 'checks if token is returned' do
        expect(json_body[:session]).to include(:token)
      end
      it 'checks if user is returned' do
        expect(json_body[:session]).to include(:user)
      end
      it 'returned token is valid' do
        expect(json_body[:session][:token]).to eq(user.token)
      end
    end

    context 'when params are invalid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        post '/api/session', params: { session: { email: user.email,
                                                  password: 'wrong_password' } }
      end

      it 'status is 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/session/:id' do
    let(:user) { FactoryBot.create(:user) }

    context 'when params are valid' do
      before do
        delete '/api/session', headers: { Authorization: user.token }
      end

      it 'returns 204 No content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when params are invalid' do
      before do
        delete '/api/session', headers: { Authorization: 'wrong_token' }
      end

      it 'status is 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
      it 'returns error' do
        expect(json_body[:errors]).to include(:token)
      end
    end
  end
end
