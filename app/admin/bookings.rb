ActiveAdmin.register Booking do
  permit_params :no_of_seats,
                :seat_price,
                :flight_id,
                :user_id
end
