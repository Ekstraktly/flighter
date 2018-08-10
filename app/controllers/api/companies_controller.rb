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
      authorize company
      render json: company
    end

    def create
      company = Company.new(company_params)
      authorize Company
      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      authorize company
      if company.update(company_params)
        render json: company, status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      authorize company
      company.destroy
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end

    def company
      @company ||= Company.find(params[:id])
    end
  end
end
