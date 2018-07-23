RSpec.describe WorldCup::Event, :world_cup_event do
  let(:world_cup_event) do
    WorldCup::Event.new(
      'id' => 13,
      'type_of_event' => 'goal',
      'player' => 'Luka Modric',
      'time' => "22'"
    )
  end

  it 'returns event ID' do
    expect(world_cup_event.id).to eq(13)
  end

  it 'returns event type' do
    expect(world_cup_event.type).to eq('goal')
  end

  it 'returns included player' do
    expect(world_cup_event.player).to eq('Luka Modric')
  end

  it 'returns time of event' do
    expect(world_cup_event.time).to eq("22'")
  end

  it 'returns to string method' do
    event = WorldCup::Event.new('id' => 12,
                                'type_of_event' => 'substitution-in',
                                'player' => 'FAHAD ALMUWALLAD',
                                'time' => "64'")
    expect(event.to_s).to eq("#12: substitution-in@64' - FAHAD ALMUWALLAD")
  end
end
