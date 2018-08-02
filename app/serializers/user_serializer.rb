class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :no_of_seats

  has_many :bookings, serializer: BookingSerializer

  def no_of_seats
    object.bookings.sum(:no_of_seats)
  end

  def bookings
    object.bookings.each do |booking|
      BookingSerializer.new(booking)
    end
  end
end
