RSpec.describe Flight do
  let(:flight) { FactoryBot.create(:flight) }

  it { is_expected.to validate_presence_of(:name) }
  describe 'uniqueness' do
    subject { described_class.new(name: 'Lufthansa', base_price: '100') }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  it 'checks if flys before lands' do
    expect(flight).not_to be_valid
  end

  it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }
end
