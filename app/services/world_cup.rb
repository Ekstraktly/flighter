require '/home/joso/Desktop/infinum_ac/'\
        'DZ3/flighter/app/services/world_cup/match.rb'
module WorldCup
  def self.format_date(date)
    "#{date.year}-#{date.month.to_s.rjust(2, '0')}"\
    "-#{date.mday.to_s.rjust(2, '0')}"
  end

  def self.matches
    response = HTTParty.get('https://worldcup.sfg.io/matches/')
    response.map { |match| WorldCup::Match.new(match) }
  end

  def self.matches_on(date)
    response = HTTParty.get('https://worldcup.sfg.io/matches/')
    right_responses = response.select do |mmatch|
      mmatch['datetime'].partition('T')[0]
                        .match(format_date(date))
    end
    right_responses.map { |match| WorldCup::Match.new(match) }
  end
end
