RSpec.describe Company do
  describe 'uniqueness' do
    subject { Company.new(name: 'Lufthansa') }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
  it { should validate_presence_of(:name) }
end