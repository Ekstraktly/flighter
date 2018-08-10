class CompanyPolicy < ApplicationPolicy
  def update?
    true
  end

  def destroy?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def index?
    true
  end
end
