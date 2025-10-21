class TournamentsController < ApplicationController
  allow_unauthorized_access

  before_action :set_tournament, only: :show

  def show
    # TODO: These queries are exactly the same as in the TournamentScoped concern
    @round = @tournament.rounds.find_by(number: @tournament.current_round_number)
    @attendance = Current.user.attendances.joins(:participation).find_by(participation: {tournament: @tournament})
    if @round.present? && @attendance.present?
      @game = @attendance.games.joins(:round).find_by(round: @round)
      @seat = @attendance.seats.joins(:game).find_by(game: @game)
      @opponent_seats = @game.seats.excluding(@seat)
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:id))
  end
end
