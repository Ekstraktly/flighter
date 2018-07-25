class BookingSerializer < ActiveModel::Serializer
  attribute :id
  attribute :flight_id
  attribute :user_id
  attribute :no_of_seats
  attribute :seat_price
end
