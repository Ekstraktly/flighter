RSpec.describe User do
  let(:user) { FactoryBot.create(:user) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
  it { is_expected.to validate_presence_of(:email) }
  describe 'uniqueness' do
    subject do
      described_class.new(email: 'bla@bla.hr',
                          first_name: 'Bla',
                          last_name: 'Milich')
    end

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_db_index(:email).unique(true) }
  end
end
