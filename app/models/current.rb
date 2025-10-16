class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
  attribute :tournament

  def round
    @round ||= Current.tournament.rounds.find_by(number: Current.tournament.current_round_number)
  end

  def attendance
    @attendance ||= Current.user.attendances.joins(:participation).find_by(participation: {tournament: Current.tournament})
  end

  def game
    @game ||= Current.attendance.games.joins(:round).find_by(round: Current.round)
  end

  def opponents
    @opponents ||= Current.game.attendances.excluding(Current.attendance)
  end
end
