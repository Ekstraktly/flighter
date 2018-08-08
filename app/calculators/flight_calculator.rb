class FlightCalculator
  attr_reader :flight, :base_price, :flys_at

  def initialize(flight)
    @flight = flight
    @base_price = flight.base_price
    @flys_at = flight.flys_at
  end

  def price
    return base_price * 2 if flys_at <= Time.zone.now
    return base_price if flys_at > 15.days.from_now
    calculate_price
  end

  private

  def days_to_flight
    (flys_at.to_date - Date.current).to_i
  end

  def calculate_price
    base_price + (((15 - days_to_flight) / 15.0) *
      base_price).to_i
  end
end
