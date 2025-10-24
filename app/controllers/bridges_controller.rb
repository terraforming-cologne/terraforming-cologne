class BridgesController < ApplicationController
  def show
    authorize :bridge
    @tournament = Tournament.find(params.expect(:tournament_id))
    @round = @tournament.rounds.find_by(number: @tournament.current_round_number)
    @rooms = @tournament.rooms.order(:number)
    @games = @rooms.index_with do |room|
      @tournament.games.joins(:round, :room).where(games: {round: @round, tables: {room: room}}).order("tables.number")
    end
  end
end
