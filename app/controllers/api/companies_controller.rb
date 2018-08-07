module Api
  class CompaniesController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]

    def index
      authorize Company
      companies = Company.order(:name)
      companies = companies.active if params[:filter] == 'active'
      render json: companies
    end

    def show
      if company
        authorize company
        render json: company
      else
        render json: { 'errors': { "request": ['bad request'] } },
               status: :bad_request
      end
    end

    def create
      company = Company.new(company_params)
      authorize Company
      if company.save
        render json: company, status: :created
      else
        render json: { 'errors': { "request": ['bad request'] } },
               status: :bad_request
      end
    end

    def update
      authorize company
      if company.update(company_params)
        render json: company, status: :ok
      else
        render json: { 'errors': { "request": ['bad request'] } },
               status: :bad_request
      end
    end

    def destroy
      if company
        authorize company
        company.destroy
      else
        render json: { 'errors': { "request": ['bad request'] } },
               status: :bad_request
      end
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end

    def company
      @company ||= Company.find_by id: params[:id]
    end
  end
end
