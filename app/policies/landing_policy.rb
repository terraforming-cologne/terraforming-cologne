class LandingPolicy < ApplicationPolicy
  def show?
    participating?
  end

  private

  def participating?
    record.participations.exists?(user: user)
  end
end
