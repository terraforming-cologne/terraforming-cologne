class ParticipantPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user == record.user
  end

  def update?
    user == record.user
  end

  def destroy?
    user.admin? || user == record.user
  end
end
