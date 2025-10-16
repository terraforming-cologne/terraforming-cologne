class AttendancePolicy < ApplicationPolicy
  def create?
    user == record.user
  end
end
