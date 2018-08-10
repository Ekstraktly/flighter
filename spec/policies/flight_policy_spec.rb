require 'rails_helper'

describe FlightPolicy do
  subject { described_class.new(user, flight) }

  let(:flight) { FactoryBot.create(:flight) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }

  context 'when being logged in' do
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when being logged in as other user' do
    let(:user) { other_user }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
