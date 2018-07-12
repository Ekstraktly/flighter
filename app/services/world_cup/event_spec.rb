RSpec.describe WorldCup::Event, :world_cup_event do
  it 'returns event ID' do
    event = Event.new('id' => 13)
    expect(event.id).to eq(13)
  end
  it 'returns event type' do
    event = Event.new('type_of_event' => 'goal')
    expect(event.type).to eq('goal')
  end
  it 'returns included player' do
    event = Event.new('player' => 'Luka Modric')
    expect(event.player).to eq('Luka Modric')
  end
  it 'returns time of event' do
    event = Event.new('time' => "22'")
    expect(event.time).to eq("22'")
  end
  it 'returns to string method' do
    event = Event.new('id' => 12,
                      'type_of_event' => 'substitution-in',
                      'player' => 'FAHAD ALMUWALLAD',
                      'time' => "64'")
    expect(event.to_s).to eq("#12: substitution-in@64' - FAHAD ALMUWALLAD")
  end
end
