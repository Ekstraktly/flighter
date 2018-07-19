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
    test_flight = FactoryBot.build(:flight, flys_at: Time.current - 1.day)
    test_user = FactoryBot.build(:user)
    test_booking = described_class.new(flight: test_flight,
                                       user: test_user,
                                       no_of_seats: '2',
                                       seat_price: '100')
    test_booking.valid?
    expect(test_booking
      .errors[:flys_at]).to include('must be booked in the future')
  end
end
