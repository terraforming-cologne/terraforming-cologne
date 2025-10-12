class RankingsController < ApplicationController
  allow_unauthorized_access

  def show
    @tournament = Tournament.find(params[:tournament_id])

    played_ids = @tournament.attendances.includes(:games).filter { |attendance| attendance.games.count != 0 }.pluck(:id)

    @all_rounds = @tournament.rounds.includes(:attendances).merge(Attendance.with_ranking_data)
    @all_attendances = @tournament.attendances.with_ranking_data.includes(:user, scores: :round).where(id: played_ids)
    @current_round = @all_rounds.find_by(number: params[:round] || @all_rounds.maximum(:number))
    if @current_round.present?
      @rounds_up_to_current = @all_rounds.where(number: ..@current_round.number)
      @ranking_criteria = @rounds_up_to_current.index_with { |round| @all_attendances.index_with { |attendance| attendance.ranking_criteria(round) } }
      @ranked_attendances = @all_attendances.sort_by { |attendance| @ranking_criteria[@current_round][attendance] }.reverse
    end
  end
end
