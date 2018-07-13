require '/home/joso/Desktop/infinum_ac/DZ3/flighter/app/services/world_cup.rb'
class ApplicationController < ActionController::Base
  include WorldCup
  def world_cup
    if params.key?('date')
      render json: WorldCup.matches_on(extract_date).as_json(1)
    else
      render json: WorldCup.matches.as_json(1)
    end
  end

  def extract_date
    year, month, day = params['date'].split('-')
    Date.new(year.to_i, month.to_i, day.to_i)
  end
end
