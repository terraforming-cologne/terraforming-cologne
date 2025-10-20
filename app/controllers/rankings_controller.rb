class RankingsController < ApplicationController
  include TournamentScoped

  allow_unauthorized_access

  def show
    played_ids = @tournament.attendances.includes(:games).filter { |attendance| attendance.games.count != 0 }.pluck(:id)

    @all_rounds = @tournament.rounds.includes(:attendances).merge(Attendance.with_ranking_data)
    @all_attendances = @tournament.attendances.with_ranking_data.includes(:user, scores: :round).where(id: played_ids)
    @shown_round = @all_rounds.find_by(number: params[:round] || @all_rounds.maximum(:number))
    if @shown_round.present?
      @rounds_up_to_shown = @all_rounds.where(number: ..@shown_round.number)
      @ranking_criteria = @rounds_up_to_shown.index_with { |round| @all_attendances.index_with { |attendance| attendance.ranking_criteria(round) } }
      @ranked_attendances = @all_attendances.sort_by { |attendance| @ranking_criteria[@shown_round][attendance] }.reverse
    end
  end
end
