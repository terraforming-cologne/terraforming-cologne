class FirstRoundsController < ApplicationController
  before_action :set_tournament

  def new
    authorize :first_round
    @first_round = FirstRound.new(tournament: @tournament)
  end

  def create
    authorize :first_round
    @first_round = FirstRound.new(tournament: @tournament)
    if @first_round.save
      redirect_to [@tournament, :bridge], notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
  end
end
