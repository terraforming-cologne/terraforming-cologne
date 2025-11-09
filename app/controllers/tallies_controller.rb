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
      # TODO: Ugly
      redirect_to Current.user.admin? ? [@game.tournament, :bridge] : @game.tournament, notice: t(".notice")
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
      redirect_to [@game.tournament, :bridge], notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_game
    if params.include?(:game_id)
      @game = Game.find(params.expect(:game_id))
    elsif params.include?(:tournament_id)
      @tournament = Tournament.find(params.expect(:tournament_id))
      @round = @tournament.current_round
      @game = @tournament.games.joins(:users).find_by(round: @round, users: Current.user)
    end
  end

  def tally_params
    params.expect(tally: [result_attributes: [:game_id, :generations], scores_attributes: [[:rank, :seat_id, :corporation, :points]]])
  end
end
