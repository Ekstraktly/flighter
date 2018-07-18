RSpec.describe Company do
  describe 'uniqueness' do
    subject { described_class.new(name: 'Lufthansa') }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_db_index(:name).unique(true) }
end
