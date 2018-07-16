module WorldCup
  class Match
    include WorldCup
    attr_accessor :venue, :status, :starts_at

    def initialize(keys)
      @keys = keys
      @venue = keys['venue']
      @status = keys['status']
      # year, month, day, hour, minute, second = keys['datetime'].split(/[-T:]/)
      # @starts_at = Time.utc(year, month, day, hour, minute, second)
      @starts_at = Time.zone.parse(keys['datetime'])
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
        WorldCup::Event.new(event)
      end
    end

    def goals
      # all_events = @keys['home_team_events'] + @keys['away_team_events']
      # all_events.select { |event| event['type_of_event'].match('goal') }
      #          .map { |event| WorldCup::Event.new(event) }
      # all_events = events
      events.select { |event| event.type.match('goal') }
    end

    def away_team
      @keys['away_team']['country']
    end

    def home_team
      @keys['home_team']['country']
    end

    def goals_total
      # if @keys['status'].match('future')?
      if @keys['status'] == 'future'
        '--'
      else
        (@keys['away_team']['goals'].to_i + @keys['home_team']['goals'].to_i)
      end
    end

    def score
      # if @keys['status'].match('future')?
      if @keys['status'] == 'future'
        '--'
      else
        "#{@keys['home_team']['goals']} : "\
        "#{@keys['away_team']['goals']}"
      end
    end

    def as_json(_opts)
      { away_team: away_team,
        goals: goals_total,
        home_team: home_team,
        score: score,
        status: @status,
        venue: @venue }
    end
  end
end
