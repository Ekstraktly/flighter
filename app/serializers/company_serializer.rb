class CompanySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :no_of_active_flights

  def no_of_active_flights
    object.flights.where('flys_at > ?', Time.zone.now).count
  end
end
