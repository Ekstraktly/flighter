class Company < ApplicationRecord
  has_many :flights, dependent: :destroy
  validates :name, uniqueness: { case_sensitive: false },
                   length: { maximum: 45 },
                   presence: true

  scope :active, lambda {
    joins(:flights)
      .group(:id)
      .where('flys_at > ?', Time.zone.now)
  }
end
