module Api
  class CompaniesController < ApplicationController
    def index
      render json: Company.all, each_serializer: CompanySerializer
    end

    def show
      company = Company.find(params[:id])
      render json: company, serializer: CompanySerializer
    end

    def create
      company = Company.new(company_params)
      if company.save
        render json: company, status: :created
      else
        render json: company.errors, status: :bad_request
      end
    end

    def update
      @company = Company.find(params[:id])
      if @company.update(company_params)
        render json: company, status: :ok
      else
        render json: company.errors, status: :bad_request
      end
    end

    def destroy
      @company = Company.find(params[:id])
      if @company.destroy
        render json: company, status: :no_content
      else
        render json: company.errors, status: :bad_request
      end
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
