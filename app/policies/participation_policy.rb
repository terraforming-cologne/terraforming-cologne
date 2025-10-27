class ParticipationPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user == record.user
  end

  def show?
    user == record.user
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
