FactoryBot.define do
  factory :booking do
    flight_id 'A160'
    user_id '12'
    seat_price '1000'
    company_id 'AFR'
    flight
    user
  end
end
