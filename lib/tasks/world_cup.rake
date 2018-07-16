namespace :world_cup do
  desc 'world cup scores'
  task :scores, [:date] => :environment do |_t, args|
    # year, month, day = args.date.split('-')
    date_match = Date.parse(args.date)
    # matches = WorldCup.matches_on(Date.new(year.to_i, month.to_i, day.to_i))
    matches = WorldCup.matches_on(date_match)
    tp matches, 'venue',
       { home_team_name: { display_name: 'home_team' } },
       { away_team_name: { display_name: 'away_team' } },
       score: ->(u) { "#{u.home_team_goals} : #{u.away_team_goals}" }
  end
end
