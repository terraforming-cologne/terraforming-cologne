class TournamentPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || participating?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  private

  def participating?
    record.participations.joins(:user).where(participations: {user: user}).exists?
  end
end
