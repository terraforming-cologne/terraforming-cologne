class RankingsController < ApplicationController
  allow_unauthorized_access

  def show
    @tournament = Tournament.find(params[:tournament_id])

    # TODO: Extract the concept of people actually playing at the tournament
    played_ids = @tournament.participations.includes(:games).filter { |participation| participation.games.count != 0 }.pluck(:id)

    @all_rounds = @tournament.rounds.includes(:participations).merge(Participation.with_ranking_data)
    @all_participations = @tournament.participations.with_ranking_data.includes(:user, scores: :round).where(id: played_ids)
    @current_round = @all_rounds.find_by(number: params[:round] || @all_rounds.maximum(:number))
    if @current_round.present?
      @rounds_up_to_current = @all_rounds.where(number: ..@current_round.number)
      @ranking_criteria = @rounds_up_to_current.index_with { |round| @all_participations.index_with { |participation| participation.ranking_criteria(round) } }
      @ranked_participations = @all_participations.sort_by { |participation| @ranking_criteria[@current_round][participation] }.reverse
    end
  end
end
