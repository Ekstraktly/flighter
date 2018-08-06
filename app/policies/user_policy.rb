class UserPolicy < ApplicationPolicy
  def update?
    record == user
  end

  def destroy?
    record == user
  end

  def show?
    record == user
  end

  def create?
    true
  end

  def index?
    true
  end
end
