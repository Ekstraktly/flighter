require 'rails_helper'

describe BookingPolicy do
  subject { described_class.new(user, booking) }

  let(:booking) { FactoryBot.create(:booking, user: user) }

  context 'accessing own booking' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'accessing other users booking' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:booking) { FactoryBot.create(:booking, user: other_user) }


    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end