class RankingsController < ApplicationController
  allow_unauthorized_access

  def show
    @tournament = Tournament.includes(games: [:result, :scores]).find(params.expect(:tournament_id))
    @round = if params[:round].present?
      @tournament.rounds.find_by(number: params[:round])
    elsif @tournament.tallied?
      @tournament.last_round
    else
      @tournament.previous_round
    end
    @rounds_up_to_current = @tournament.rounds.merge(Participation.with_ranking_data).where(number: ..(@round&.number || 1))

    if @round&.tallied?
      attending_participations = @tournament.participations.where.associated(:games).distinct
      @participations = @tournament.participations.with_ranking_data.includes(:user).where(id: attending_participations)
      @ranking_criteria = @rounds_up_to_current.index_with { |round| @participations.index_with { it.ranking_criteria(round) } }
      @participations = @participations.to_a.sort_by { @ranking_criteria[@round][it] }.reverse!
    end
  end
end
