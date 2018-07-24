RSpec.describe 'Companys API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /companies' do
    before do
      FactoryBot.create_list(:company, 3)
      get '/api/companies'
    end

    it 'successfully returns a list of companys' do
      expect(json_body[:companies].length).to eq(3)
    end
    it 'returns status OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /companies/:id' do
    let(:company) { FactoryBot.create(:company) }

    before { get "/api/companies/#{company.id}" }

    it 'returns a single company' do
      expect(json_body[:company]).to include(:name)
    end
    it 'returns stauts OK' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/companies/' do
    let(:company_params) { FactoryBot.attributes_for(:company) }

    context 'when params are valid' do
      it 'creates a company' do
        expect do
          post '/api/companies', params: { company: company_params }
        end.to change(Company, :count).by(1)
        expect(json_body[:company]).to include(name: company_params[:name])
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/companies', params: { company: { name: '' } }
        end.to change(Company, :count).by(0)
        expect(response).to have_http_status(:bad_request)
        expect(json_body[:errors]).to include(:name)
      end
    end
  end

  describe 'UPDATE /api/companys/:id' do
    let(:companies) { FactoryBot.create_list(:company, 3) }

    before do
      put "/api/companies/#{companies.first.id}",
          params: { company: { name: 'Afrika Airlines' } }
    end

    context 'when params are valid' do
      it 'updates a company' do
        expect(json_body[:company]).to include(name: 'Afrika Airlines')
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE /api/companies/:id' do
    let(:company) { FactoryBot.create(:company) }

    before { company }

    context 'when params are valid' do
      it 'deletes a company' do
        expect do
          delete "/api/companies/#{company.id}"
        end.to change(Company, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
