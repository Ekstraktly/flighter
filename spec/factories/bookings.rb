FactoryBot.define do
  factory :booking do
    no_of_seats 3
    seat_price 100
    user
    flight { FactoryBot.create(:flight, flys_at: Time.current + 1.day) }
  end
end
