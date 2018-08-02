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
    booking = FactoryBot.build(:booking)
    booking.valid?
    expect(booking.errors[:flight])
      .to include('must be booked in the future')
  end
end
