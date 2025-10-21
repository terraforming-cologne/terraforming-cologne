class Admin::Tournament::BridgesController < ApplicationController
  def show
    authorize :bridge
    @tournament = Tournament.find(params.expect(:tournament_id))
    @round = @tournament.rounds.find_by(number: @tournament.current_round_number)
    @rooms = @tournament.rooms
    @games = @rooms.index_with do |room|
      @tournament.games.joins(:round).where(games: {round: @round})
    end
  end
end
