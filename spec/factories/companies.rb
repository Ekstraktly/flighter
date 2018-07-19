FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Air #{n}" }
  end
end
