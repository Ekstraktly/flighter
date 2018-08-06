class BookingPolicy < ApplicationPolicy
  def update?
    record.user == user
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
