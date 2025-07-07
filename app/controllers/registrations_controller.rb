class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  allow_unauthorized_access

  def new
    redirect_to :root, notice: t(".no_tournaments_planned") and return unless Tournament.planned?

    redirect_to [:new, Tournament.next, :participation] and return if authenticated?

    @user = User.new
    session[:return_to_after_authenticating] = new_tournament_participation_path(Tournament.next)
  end
end
