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
    record.participations.includes(:user).map(&:user).include?(user)
  end
end
