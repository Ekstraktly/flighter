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

  describe 'POST /bookings' do
    let(:user) { FactoryBot.create(:user) }
    let(:flight) { FactoryBot.create(:flight, no_of_seats: 100) }

    before do
      FactoryBot.create(:booking,
                        user: user,
                        flight: flight,
                        no_of_seats: 98)
    end

    context 'when flight is overbooked' do
      it 'returns error message' do
        booking = FactoryBot.build(:booking, flight: flight, no_of_seats: 3)
        booking.valid?
        expect(booking.errors[:no_of_seats])
          .to include('not enough seats on this flight')
      end
    end

    context 'when flight is not overbooked' do
      it 'returns valid booking' do
        booking = FactoryBot.build(:booking, flight: flight, no_of_seats: 2)
        expect(booking.valid?).to be true
      end
    end
  end
end
