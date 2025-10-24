class BridgePolicy < ApplicationPolicy
  def show?
    user.admin?
  end
end
