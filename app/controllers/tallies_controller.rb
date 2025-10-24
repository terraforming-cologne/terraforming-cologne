class TalliesController < ApplicationController
  before_action :set_game

  def new
    @tally = Tally.new(game: @game)
    authorize @tally
    redirect_to @game.tournament, notice: t(".already_tallied") and return if @game.tallied?
  end

  def create
    @tally = Tally.new(tally_params.merge(game: @game))
    authorize @tally
    if @tally.save
      redirect_to @game.tournament, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @tally = Tally.new(game: @game)
    authorize @tally
  end

  def update
    @tally = Tally.new(tally_params.merge(game: @game))
    authorize @tally
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
