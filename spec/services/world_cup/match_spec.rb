RSpec.describe WorldCup::Match, :match do
  let(:match) do
    WorldCup::Match.new(
      'venue' => 'Rostov Arena',
      'location' => 'Rostov Arena', 'status' => 'completed',
      'fifa_id' => '300331530',
      'datetime' => '2018-06-20T15:00:00',
      'home_team' => { 'country' => 'Uruguay', 'code' => 'URU', 'goals' => 1 },
      'away_team' => { 'country' => 'Saudi Arabia',
                       'code' => 'KSA', 'goals' => 0 },
      'winner' => 'Uruguay', 'winner_code' => 'URU', 'home_team_events' =>
      [{ 'id' => 276, 'type_of_event' => 'goal',
         'player' => 'Luis SUAREZ',
         'time' => "23'" }],
      'away_team_events' => [{ 'id' => 12,
                               'type_of_event' => 'substitution-in',
                               'player' => 'FAHAD ALMUWALLAD',
                               'time' => "64'" }]
    )
  end

  it 'returns match venue' do
    expect(match.venue).to eq('Rostov Arena')
  end
  describe '#match_status' do
    it 'returns match status' do
      expect(match.status).to eq('completed')
    end
  end

  describe 'home_team' do
    it 'returns home team goals' do
      expect(match.home_team_goals).to eq(1)
    end
    it 'returns home team name' do
      expect(match.home_team_name).to eq('Uruguay')
    end
    it 'returns home team code' do
      expect(match.home_team_code).to eq('URU')
    end
  end

  describe 'away team' do
    it 'returns away team goals' do
      expect(match.away_team_goals).to eq(0)
    end
    it 'returns away team name' do
      expect(match.away_team_name).to eq('Saudi Arabia')
    end
    it 'returns away team code' do
      expect(match.away_team_code).to eq('KSA')
    end
  end

  describe 'arrays' do
    it 'checks events array length' do
      expect(match.events.length).to eq(2)
    end
    it 'checks if all elements are instances of Event' do
      expect(match.events).to all(be_an(WorldCup::Event))
    end
    it 'checks goals array length' do
      expect(match.goals.length).to eq(1)
    end
  end
end
