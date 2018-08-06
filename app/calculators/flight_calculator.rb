class FlightCalculator
  attr_reader :flight

  def initialize(flight)
    @flight = flight
    @base_price = flight.base_price
    @flys_at = flight.flys_at
  end

  def price
    return @base_price * 2 if @flys_at <= Time.zone.now

    @base_price + (((15 - days_to_flight) / 15.0) *
      @base_price).to_i
  end

  private

  def days_to_flight
    (@flys_at.to_date - Date.current).to_i
  end
end
