class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def world_cup
    if params.key?('date')
      render json: WorldCup.matches_on(extract_date)
    else
      render json: WorldCup.matches
    end
  end

  def extract_date
    Date.parse(params['date'])
  end
end
