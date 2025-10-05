class RankingsController < ApplicationController
  allow_unauthorized_access

  def show
    @tournament = Tournament.find(params[:tournament_id])
    @round = @tournament.rounds.with_ranking.find_by(number: params[:round] || 1)
    @ranking_criteria = @round.participations.index_with { |participation| participation.ranking_criteria(@round) }
    @participations = @round.participations.sort_by { |participation| @ranking_criteria[participation] }.reverse
  end
end
