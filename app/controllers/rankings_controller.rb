class RankingsController < ApplicationController
  allow_unauthorized_access

  def show
    @tournament = Tournament.includes(:rounds).find(params[:tournament_id])
    @current_round = @tournament.rounds.includes(participations: :user).find_by(number: params[:round] || @tournament.rounds.maximum(:number))
    @all_rounds = @tournament.rounds
    @rounds_up_to_current = @tournament.rounds.includes(participations: {scores: :round}).with_ranking.where(number: ..@current_round.number)
    @ranking_criteria = @rounds_up_to_current.index_with { |round| round.participations.index_with { |participation| participation.ranking_criteria(round) } }
    @participations = @current_round.participations.sort_by { |participation| @ranking_criteria[@current_round][participation] }.reverse
  end
end
