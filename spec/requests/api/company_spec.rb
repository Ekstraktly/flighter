RSpec.describe 'Companys API', type: :request do
  include TestHelpers::JsonResponse
  describe 'GET /companies' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }

      before do
        FactoryBot.create_list(:company, 3)
        get '/api/companies', headers: { Authorization: user.token }
      end

      it 'successfully returns a list of companies' do
        expect(json_body[:companies].length).to eq(3)
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
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

  describe 'GET /companies/:id' do
    context 'when authenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:company) { FactoryBot.create(:company) }

      before do
        get "/api/companies/#{company.id}",
            headers: { Authorization: user.token }
      end

      it 'returns a single company' do
        expect(json_body[:company]).to include(:name)
      end
      it 'returns stauts OK' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when unauthenticated user and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:company) { FactoryBot.create(:company) }

      before do
        get "/api/companies/#{company.id}",
            headers: { Authorization: 'wrong_token' }
      end

      it 'returns status 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
      it '  returns token is invalid error' do
        expect(json_body[:errors][:token]).to eq(['is invalid'])
      end
    end
  end

  describe 'POST /api/companies/' do
    let(:user) { FactoryBot.create(:user) }
    let(:company_params) { FactoryBot.attributes_for(:company) }

    context 'when authenticated user and params are valid' do
      it 'creates a company' do
        expect do
          post '/api/companies', params: { company: company_params },
                                 headers: { Authorization: user.token }
        end.to change(Company, :count).by(1)
      end
      it 'checks company name' do
        post '/api/companies', params: { company: company_params },
                               headers: { Authorization: user.token }

        expect(json_body[:company]).to include(name: company_params[:name])
      end
    end

    context 'when unauthenticated user and valid params' do
      it 'creates a company' do
        expect do
          post '/api/companies', params: { company: company_params },
                                 headers: { Authorization: 'wrong_token' }
        end.to change(Company, :count).by(0)
      end
      it 'returns status Unauthorized' do
        post '/api/companies', params: { company: { name: '' } },
                               headers: { Authorization: 'wrong_token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when params are invalid' do
      it 'returns 402 bad request' do
        expect do
          post '/api/companies', params: { company: { name: '' } },
                                 headers: { Authorization: user.token }
        end.to change(Company, :count).by(0)
      end
      it 'returns bad request' do
        post '/api/companies', params: { company: { name: '' } },
                               headers: { Authorization: user.token }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'UPDATE /api/companys/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:companies) { FactoryBot.create_list(:company, 3) }

    before do
      put "/api/companies/#{companies.first.id}",
          params: { company: { name: 'Afrika Airlines' } },
          headers: { Authorization: user.token }
    end

    context 'when params are valid' do
      it 'updates a company' do
        expect(json_body[:company]).to include(name: 'Afrika Airlines')
      end
      it 'returns status OK' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when params are invalid' do
      before do
        put "/api/companies/#{companies.first.id}",
            params: { company: { name: '' } },
            headers: { Authorization: user.token }
      end

      # it 'does not update a company name' do
      #  expect(json_body[:errors]).to include(:name)
      # end
      it 'returns 400 Bad request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is unauthenticated and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:company) { FactoryBot.create(:company) }

      before do
        put "/api/companies/#{company.id}",
            params: { company: { name: 'Afrika Airlines' } },
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

  describe 'DELETE /api/companies/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:companies) { FactoryBot.create_list(:company, 3) }

    before do
      user
      companies
    end

    it 'deletes a company' do
      expect do
        delete "/api/companies/#{companies.first.id}",
               headers: { Authorization: user.token }
      end.to change(Company, :count).by(-1)
    end
    it 'returns status No content' do
      delete "/api/companies/#{companies.first.id}",
             headers: { Authorization: user.token }
      expect(response).to have_http_status(:no_content)
    end

    context 'when user is authenticated params are invalid' do
      it 'does not delete a company' do
        expect do
          delete '/api/companies/wrong_company',
                 headers: { Authorization: user.token }
        end.to change(Company, :count).by(0)
      end
      it 'returns status Bad request' do
        delete '/api/companies/wrong_company',
               headers: { Authorization: user.token }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is unauthenticated and params are valid' do
      let(:user) { FactoryBot.create(:user) }
      let(:companies) { FactoryBot.create_list(:company, 3) }

      before do
        user
        companies
      end

      it "doesn't delete company" do
        delete "/api/companies/#{companies.first.id}",
               headers: { Authorization: 'wrong_token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
