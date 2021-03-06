FactoryBot.define do
  factory :user do
    first_name 'Mileni'
    last_name 'Milich'
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'password'
  end
end
