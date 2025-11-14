class TablesController < ApplicationController
  def index
    authorize Table
    @tournament = Tournament.find(params.expect(:tournament_id))
    @tables = @tournament.tables
  end
end
