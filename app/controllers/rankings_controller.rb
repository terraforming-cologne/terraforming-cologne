class RankingsController < ApplicationController
  include TournamentScoped

  allow_unauthorized_access

  def show
    @tournament = Tournament.find(params.expect(:tournament_id))
    played_ids = @tournament.attendances.includes(:games).filter { |attendance| attendance.games.count != 0 }.pluck(:id)

    @rounds = @tournament.rounds.where(id: Round.ready_for_ranking)
    @attendances = @tournament.attendances.with_ranking_data.includes(:user, scores: :round).where(id: played_ids)
    if @rounds.any?
      @shown_round = @rounds.find_by(number: params[:round] || @rounds.unscope(:group).maximum(:number))
      @rounds_up_to_shown = @rounds.includes(:attendances).merge(Attendance.with_ranking_data).where(number: ..@shown_round.number)
      @ranking_criteria = @rounds_up_to_shown.index_with { |round| @attendances.index_with { |attendance| attendance.ranking_criteria(round) } }
      @ranked_attendances = @attendances.sort_by { |attendance| @ranking_criteria[@shown_round][attendance] }.reverse
    end
  end
end
