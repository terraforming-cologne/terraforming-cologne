class BridgesController < ApplicationController
  def show
    authorize :bridge
    @tournament = Tournament.find(params.expect(:tournament_id))
    @round = @tournament.current_round
    @rooms = @tournament.rooms.includes(tables: :games).order(:number, "tables.number")
    @games = @rooms.index_with do |room|
      @tournament.games.joins(:round, :room).where(round: @round, room: room).order("tables.number")
    end
    if @tournament.next_round.present?
      @attendances = @tournament.next_round.attendances.joins(:user).order("users.name")
    end
  end
end
