FactoryBot.define do
  factory :flight do
    name 'A160'
    no_of_seats '120'
    base_price '500'
    flys_at '2018-07-17'
    lands_at '2018-06-16'
    company_id 'AFR'
    company
  end
end
