class TalliesController < ApplicationController
  allow_unauthorized_access

  before_action :set_game

  def new
    redirect_to @game.tournament, notice: t(".already_tallied") and return if @game.tallied?
    @tally = Tally.new(game: @game)
  end

  def create
    @tally = Tally.new(tally_params.merge(game: @game))
    if @tally.save
      redirect_to @game.tournament, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @tally = Tally.new(game: @game)
  end

  def update
    @tally = Tally.new(tally_params.merge(game: @game))
    if @tally.save
      redirect_back_or_to [:admin, @game.tournament, :bridge], notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_game
    @game = Game.find(params.expect(:game_id))
  end

  def tally_params
    params.expect(tally: [result_attributes: [:game_id, :generations], scores_attributes: [[:rank, :seat_id, :corporation, :points]]])
  end
end
