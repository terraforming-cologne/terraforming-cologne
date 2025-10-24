class FirstRoundPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
