RSpec.describe Booking do
  it { is_expected.to have_db_index(:user_id) }
  it { is_expected.to have_db_index(:flight_id) }
  it { is_expected.to validate_presence_of(:seat_price) }
  it {
    is_expected.to validate_numericality_of(:seat_price)
      .is_greater_than(0)
  }
  it { is_expected.to validate_presence_of(:no_of_seats) }
  it {
    is_expected.to validate_numericality_of(:no_of_seats)
      .is_greater_than(0)
  }
  it 'checks if booking is in past' do
    flight = FactoryBot.create(:flight, flys_at: Time.current - 1.day)
    user = FactoryBot.create(:user)
    booking = described_class.new(flight: flight,
                                  user: user,
                                  no_of_seats: 2,
                                  seat_price: 100)
    booking.valid?
    expect(booking.errors[:flys_at])
      .to include('must be booked in the future')
  end
end
