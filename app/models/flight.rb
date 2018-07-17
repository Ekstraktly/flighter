class Flight < ActiveRecord::Base
  belongs_to :company
  has_many :bookings

  validates :name, length: { maximum: 45 },
                   presence: true,
                   uniqueness: { case_sensitive: false }
  validates :no_of_seats, numericality: { only_integer: true }
  validates :base_price, numericality: { greater_than: 0 },
                         presence: true,
  validate :flys_before_lands

  def flys_before_lands
    return if Date.parse(:flys_at) < Date.parse(:lands_at)
  end
end