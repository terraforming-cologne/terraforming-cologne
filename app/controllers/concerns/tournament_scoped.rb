module TournamentScoped
  extend ActiveSupport::Concern

  ACTIONS = %w[index new create].freeze

  included do
    # NOTE: We use if: here instead of only: because not all controllers that include TournamentScoped have all three actions defined.
    with_options if: -> { it.action_name.in?(["index", "new", "create"]) } do
      before_action :set_tournament_data
      before_action :set_attendance_data
    end
  end

  private

  def set_tournament_data
    @tournament = Tournament.find(params.expect(:tournament_id))
    @round = @tournament.rounds.find_by(number: @tournament.current_round_number)
  end

  def set_attendance_data
    @attendance = Current.user.attendances.joins(:participation).find_by(participation: {tournament: @tournament})
    if @round.present? && @attendance.present?
      @game = @attendance.games.joins(:round).find_by(round: @round)
      @seat = @attendance.seats.joins(:game).find_by(game: @game)
      @opponent_seats = @game.seats.excluding(@seat)
    end
  end

  def defined_actions
    self.class.action_methods & ACTIONS
  end
end
