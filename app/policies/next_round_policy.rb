class NextRoundPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
