module TournamentScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_tournament
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
    Current.tournament = @tournament
  end
end
