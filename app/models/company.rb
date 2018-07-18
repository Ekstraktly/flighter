class Company < ApplicationRecord
  has_many :flights
  validates :name, uniqueness: { case_sensitive: false },
                   length: { maximum: 45 },
                   presence: true
end
