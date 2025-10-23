class NextRoundsController < ApplicationController
  before_action :set_tournament

  def new
    authorize :next_round
    @next_round = NextRound.new(tournament: @tournament)
  end

  def create
    authorize :next_round
    @next_round = NextRound.new(next_round_params.merge(tournament: @tournament))
    if @next_round.save
      redirect_to [@tournament, :bridge], notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
  end

  def next_round_params
    params.expect(next_round: [participation_ids: []])
  end
end
