RSpec.describe Flight do
  let(:flight) { FactoryBot.create(:flight) }

  it { is_expected.to validate_presence_of(:name) }

  describe 'uniqueness' do
    subject { described_class.new(name: 'Lufthansa', base_price: '100') }

    it {
      is_expected.to validate_uniqueness_of(:name)
        .case_insensitive
        .scoped_to(:company_id)
    }
  end

  it { is_expected.to validate_presence_of(:base_price) }
  it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }
  it 'checks if flys before lands' do
    test_flight = FactoryBot.build(:flight,
                                   flys_at: Time.current + 1.day,
                                   lands_at: Time.current - 1.day)
    test_flight.valid?
    expect(test_flight
      .errors[:lands_at]).to include('must be later than flys_at')
  end
end
