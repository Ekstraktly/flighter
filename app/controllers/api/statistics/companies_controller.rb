module Api
  module Statistics
    class CompaniesController < ApplicationController
      before_action :authentificate, only: [:index]

      def index
        render json: companies_with_stats,
               each_serializer: Statistics::CompanySerializer
      end

      def companies_with_stats
        CompaniesQuery.new(relation: Company.all)
                      .with_stats
                      .includes(:flights)
      end
    end
  end
end
