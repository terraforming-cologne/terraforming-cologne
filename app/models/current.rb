class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  attribute :tournament

  def attendance
    Current.tournament.attendances.includes(:user).find { |attendance| attendance.user == Current.user }
  end
end
