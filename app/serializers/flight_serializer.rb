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

  def current_price
    if days_to_flight(object.flys_at) >= 15
      object.base_price
    else
      calculate_price(object.base_price, object.flys_at)
    end
  end

  def days_to_flight(flight_date)
    ((flight_date - Time.zone.now) / (60 * 60 * 24)).to_i
  end

  def calculate_price(base_price, flys_at)
    if flys_at < Time.zone.now
      base_price +
        (((15 - days_to_flight(flys_at)) / 15.0) * base_price)
        .to_i
    else
      object.base_price * 2
    end
  end
end
