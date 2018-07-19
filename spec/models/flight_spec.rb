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
end
