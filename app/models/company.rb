class Company < ApplicationRecord
  has_many :flights
  validates :name, length: { maximum: 45 },
                   uniqueness: { case_sensitive: false },
                   presence: true
end
