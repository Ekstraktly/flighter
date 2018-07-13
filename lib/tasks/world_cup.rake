# require 'home/joso/Desktop/infinum_ac/DZ3/flighter/app/services/world_cup.rb'
namespace :world_cup do
  include WorldCup
  desc 'world cup scores'
  task :scores, [:date] => [:environment] do |_t, args|
    year, month, day = args.date.split('-')
    matches = WorldCup.matches_on(Date.new(year.to_i, month.to_i, day.to_i))
    tp matches, 'venue',
       { home_team_name: { display_name: 'home_team' } },
       { away_team_name: { display_name: 'away_team' } },
       score: ->(u) { "#{u.home_team_goals} : #{u.away_team_goals}" }
  end
end
