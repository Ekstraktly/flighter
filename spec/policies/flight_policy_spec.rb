require 'rails_helper'

describe FlightPolicy do
  subject { described_class.new(user, flight) }

  let(:flight) { FactoryBot.create(:flight) }

  context 'being logged in' do
    let(:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end