class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings
  has_many :users, through: :bookings

  validates :name, length: { maximum: 45 },
                   presence: true,
                   uniqueness: { case_sensitive: false, scope: :company_id }
  validates :no_of_seats, numericality: { greater_than: 0 }, presence: true
  validates :base_price, numericality: { greater_than: 0 },
                         presence: true
  validates :flys_at, presence: true
  validates :lands_at, presence: true
  validate :flys_before_lands

  def flys_before_lands
    return if flys_at && lands_at && (flys_at < lands_at)
    errors.add(:land_at, 'must be later than flys_at')
  end
end
