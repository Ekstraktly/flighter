module Api
  class CompaniesController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]
    before_action :current_user, only: [:index,
                                        :show,
                                        :update,
                                        :destroy,
                                        :create]

    def index
      render json: Company.all
    end

    def show
      company
      if @company
        render json: @company
      else
        render json: { errors: company.errors }, status: :bad_request
      end
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
      if @company
        @company.destroy
      else
        render json: { errors: @current_user.errors }, status: :bad_request
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
