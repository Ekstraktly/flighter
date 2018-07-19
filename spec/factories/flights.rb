FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "A#{n}" }
    no_of_seats 120
    base_price 500
    flys_at { Time.current + 1.day }
    lands_at { Time.current + 2.days }
    company
  end
end
