RSpec.describe 'Flight Calculator', type: :request do
  describe 'Calculating seat price' do
    let(:user) { FactoryBot.create(:user) }

    context 'when booking is more than two weeks before flight' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: 16.days.from_now,
                          lands_at: 17.days.from_now,
                          base_price: 100)
      end

      it 'returns base price' do
        expect(FlightCalculator.new(flight).price).to eq(100)
      end
    end

    context 'when booking is in less than two weeks' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: 10.days.from_now,
                          lands_at: 11.days.from_now,
                          base_price: 100)
      end

      it 'returns X_days/15 * base_price' do
        expect(FlightCalculator.new(flight).price).to eq(133)
      end
    end

    context 'when flight has departured' do
      let(:flight) do
        FactoryBot.create(:flight,
                          flys_at: Time.zone.now - 1.days,
                          lands_at: Time.zone.now,
                          base_price: 100)
      end

      it 'returns X_days/15 * base_price' do
        expect(FlightCalculator.new(flight).price).to eq(200)
      end
    end
  end
end