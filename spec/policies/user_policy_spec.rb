require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(user, user_resource) }

  let(:user_resource) { FactoryBot.create(:user) }

  context 'accessing own user' do
    let(:user) { user_resource }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'accessing other user' do
    let (:user) { FactoryBot.create(:user) }

    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end
end