class LandingsController < ApplicationController
  def show
    @tournament = Tournament.find(params.expect(:tournament_id))
    authorize @tournament, policy_class: LandingPolicy
  end
end
