module Api
  class CompaniesController < ApplicationController
    before_action :authentificate, only: [:index,
                                          :show,
                                          :update,
                                          :destroy,
                                          :create]

    def index
      render json: if params[:filter] == 'active'
                     Company.joins(:flights).group(:id)
                            .where('flys_at > ?', Time.zone.now)
                       .all
                            .order(:name)
                   else
                     Company.all.order(:name)
                   end
    end

    def show
      if company
        render json: company
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
      if company.update(company_params)
        render json: company, status: :ok
      else
        render json: { errors: company.errors }, status: :bad_request
      end
    end

    def destroy
      if company
        company.destroy
      else
        render json: { errors: current_user.errors }, status: :bad_request
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
