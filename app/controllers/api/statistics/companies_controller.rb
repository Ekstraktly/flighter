module Api
  module Statistics
    class CompaniesController < ApplicationController
      before_action :authentificate, only: [:index]

      def index
        render json: Company.includes(:flights),
               each_serializer: Statistics::CompanySerializer
      end
    end
  end
end
