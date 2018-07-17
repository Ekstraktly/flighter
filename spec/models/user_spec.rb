RSpec.describe User do
  let!(:user) { User.create(first_name: 'M', last_name: 'Mickey', email: 'mike@mickey.com') }
  it { should validate_presence_of(:first_name) }
  it { should validate_length_of(:first_name).is_at_least(2) }
  it { should validate_presence_of(:email) }
  # it { should validate_uniqueness_of(:email).case_insensitive }
end
