require_relative './event.rb'
module WorldCup
  class Match
    include WorldCup
    attr_accessor :venue, :status, :starts_at

    def initialize(keys)
      @keys = keys
      @venue = keys['venue']
      @status = keys['status']
      year, month, day, hour, minute, second = keys['datetime'].split(/[-T:]/)
      # second = second.slice(0..-1)
      @starts_at = Time.utc(year, month, day, hour, minute, second)
    end

    def home_team_goals
      @keys['home_team']['goals']
    end

    def home_team_name
      @keys['home_team']['country']
    end

    def home_team_code
      @keys['home_team']['code']
    end

    def away_team_goals
      @keys['away_team']['goals']
    end

    def away_team_name
      @keys['away_team']['country']
    end

    def away_team_code
      @keys['away_team']['code']
    end

    def events
      all_events = @keys['home_team_events'] + @keys['away_team_events']
      all_events.map do |event|
        WorldCup::Event.new('id' => event['id'],
                            'player' => event['player'],
                            'time' => event['time'],
                            'type_of_event' => event['type_of_event'])
      end
    end

    def goals
      all_events = @keys['home_team_events'] + @keys['away_team_events']
      all_events.select { |event| event['type_of_event'].match('goal') }
                .map { |event| WorldCup::Event.new(event) }
    end

    def away_team
      @keys['away_team']['country']
    end

    def home_team
      @keys['home_team']['country']
    end

    def goals_total
      if (home_team_goals.to_i + away_team_goals.to_i).zero?
        '--'
      else
        (@keys['away_team']['goals'].to_i + @keys['home_team']['goals'].to_i)
      end
    end

    def score
      if !@keys['status'].match('future')
        "#{@keys['home_team']['goals']} : "\
        "#{@keys['away_team']['goals']}"
      else
        '--'
      end
    end

    def as_json(_opts)
      { away_team: away_team, goals: goals_total,
        home_team: home_team,
        score: score,
        status: @status,
        venue: @venue }
    end
  end
end
