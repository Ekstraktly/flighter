module Api
  class CompaniesController < ApplicationController
    def index
      render json: Company.all
    end

    def show
      company
      render json: @company
    end

    def create
      company = Company.new(company_params)
      if company.save
        render json: company, status: :created
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def update
      company
      if @company.update(company_params)
        render json: @company, status: :ok
      else
        render json: { errors: @company.errors }, status: :bad_request
      end
    end

    def destroy
      company
      @company.destroy
      head :no_content
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
