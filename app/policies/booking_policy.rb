class BookingPolicy < ApplicationPolicy
  def update?
    record.user == user && record.flight.flys_at >= Time.zone.now
  end

  def destroy?
    record.user == user
  end

  def show?
    record.user == user
  end

  def create?
    true
  end

  def index?
    true
  end
end
