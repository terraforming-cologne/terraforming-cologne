class TournamentPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    attending? || user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  private

  def attending?
    record.attendances.includes(:user).map(&:user).include?(user)
  end
end
