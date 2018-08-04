class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
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
  validate :overlaps

  scope :company_flights, lambda { |company_id|
    where(company_id: company_id.split(','))
      .where('flys_at > ?', Time.zone.now)
      .order(:flys_at, :name, :created_at)
  }

  scope :active, lambda {
    where('flys_at > ?', Time.zone.now)
      .order(:flys_at, :name, :created_at)
      .includes(:company)
  }

  def flys_before_lands
    return if flys_at && lands_at && (flys_at < lands_at)
    errors.add(:lands_at, 'must be later than flys_at')
    errors.add(:flys_at, 'must be later than flys_at')
  end

  def overlaps
    return if flys_at &&
              lands_at &&
              company &&
              company.flights.where.not(id: id)
                     .where('(flys_at, lands_at) OVERLAPS (?,?)',
                            flys_at,
                            lands_at).empty?
    overlap_errors
  end

  def current_price
    return base_price * 2 if flys_at <= Time.zone.now

    base_price + (((15 - days_to_flight) / 15.0) * base_price).to_i
  end

  def days_to_flight
    (flys_at.to_date - Date.current).to_i
  end

  def overlap_errors
    errors.add(:flys_at, "flights can't overlap")
    errors.add(:lands_at, "flights can't overlap")
  end
end
