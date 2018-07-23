RSpec.describe 'Users API', type: :request do
  # include TestHelpers::JsonResponse
  describe 'GET /users' do
    let(:users) { FactoryBot.create_list(:user, 3) }

    it 'successfully returns a list of users' do
      get '/api/users'
      expect(response).to have_http_status(:ok)
    end
  end
end
