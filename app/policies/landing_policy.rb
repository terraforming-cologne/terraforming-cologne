class LandingPolicy < ApplicationPolicy
  def show?
    participating?
  end

  private

  def participating?
    record.participations.joins(:user).where(participations: {user: user}).exists?
  end
end
