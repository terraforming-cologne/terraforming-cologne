class RankingsController < ApplicationController
  include TournamentScoped

  allow_unauthorized_access

  def show
    @tournament = Tournament.find(params.expect(:tournament_id))
    played_ids = @tournament.participations.includes(:games).filter { |participation| participation.games.size != 0 }.pluck(:id)

    @rounds = @tournament.rounds.where(id: Round.ready_for_ranking)
    @participations = @tournament.participations.with_ranking_data.includes(:user, :rounds).where(id: played_ids)
    if @rounds.any?
      @shown_round = @rounds.find_by(number: params[:round] || @rounds.unscope(:group).maximum(:number))
      @rounds_up_to_shown = @rounds.includes(:participations).merge(Participation.with_ranking_data).where(number: ..@shown_round.number)
      @ranking_criteria = @rounds_up_to_shown.index_with { |round| @participations.index_with { |participation| participation.ranking_criteria(round) } }
      @ranked_participations = @participations.sort_by { |participation| @ranking_criteria[@shown_round][participation] }.reverse
    end
  end
end
