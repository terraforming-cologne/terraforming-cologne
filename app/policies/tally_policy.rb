class TallyPolicy < ApplicationPolicy
  def create?
    player? || user.admin?
  end

  def update?
    user.admin?
  end

  private

  def player?
    record.game.attendances.extract_associated(:user).include?(user)
  end
end
