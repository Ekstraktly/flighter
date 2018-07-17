FactoryBot.define do
  factory :flight do
    name 'A157'
    no_of_seats '120'
    base_price '500'
    flys_at { Date.parse('2018-07-15') }
    lands_at { Date.parse('2018-07-14') }
    company_id 'LFH'
    company
  end
end
