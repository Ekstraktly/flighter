RSpec.describe Company do
  describe 'uniqueness' do
    subject { Company.new(name: 'Lufthansa') }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
  it { is_expected.to validate_presence_of(:name) }
end