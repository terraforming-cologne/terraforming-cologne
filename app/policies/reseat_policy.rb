class ReseatPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
