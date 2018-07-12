module WorldCup
  def self.matches
    response = HTTParty.get('https://worldcup.sfg.io/matches/')
    response.map { |match| WorldCup::Match.new(match) }
  end

  def matches_on(date)
    response = HTTParty.get('https://worldcup.sfg.io/matches/')
    right_responses = response.select do |match|
      match['datetime'].partition('T')[0]
                       .eq("#{date.year}-#{date.month}-#{date.mday}")
    end
    right_responses.map { |match| WorldCup::Match.new(match) }
  end
end
