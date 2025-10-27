class TournamentPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    participating? || user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  private

  def participating?
    record.participations.exists?(user: user)
  end
end
