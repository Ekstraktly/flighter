RSpec.describe 'Companys Statistics API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET api/statistics/companies' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create_list(:company, 3)
        get '/api/statistics/companies', headers: { Authorization: user.token }
      end

      it 'successfully returns a list of companies' do
        expect(json_body[:companies].length).to eq(3)
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns total revenue' do
        expect(json_body[:companies].first).to include(:total_revenue)
      end
    end

    context 'when unauthenticated user' do
      let(:user) { FactoryBot.create(:user) }

      before do
        get '/api/companies', headers: { Authorization: 'wrong_token' }
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
