class FlightSerializer < ActiveModel::Serializer
  attribute :id
  attribute :company_id
  attribute :company_name
  attribute :name
  attribute :no_of_seats
  attribute :base_price
  attribute :flys_at
  attribute :lands_at
  attribute :no_of_booked_seats
  attribute :current_price
  belongs_to :company, serializer: CompanySerializer

  def no_of_booked_seats
    object.bookings.sum(:no_of_seats)
  end

  def company_name
    object.company.name
  end

  def seat_price
    FlightCalculator.new(object).price
  end

  def current_price
    FlightCalculator.new(object).price
  end
end
