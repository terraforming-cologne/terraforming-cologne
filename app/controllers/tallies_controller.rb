class TalliesController < ApplicationController
  include TournamentScoped

  allow_unauthorized_access

  def new
    redirect_to @tournament, notice: t(".no_current_game") and return if @game.blank?
    redirect_to @tournament, notice: t(".already_tallied") and return if @game.result.present?
    @tally = Tally.build_for(game: @game)
  end

  def create
    @tally = Tally.new(tally_params)
    if @tally.save
      redirect_to @tournament, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def tally_params
    params.expect(tally: [result_attributes: [:game_id, :generations], scores_attributes: [[:rank, :seat_id, :corporation, :points]]])
  end
end
