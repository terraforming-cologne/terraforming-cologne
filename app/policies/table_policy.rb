class TablePolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
