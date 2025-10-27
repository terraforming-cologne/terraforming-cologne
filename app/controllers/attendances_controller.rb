class AttendancesController < ApplicationController
  before_action :set_tournament

  def create
    @participation = @tournament.participations.find_by(user: Current.user)
    @attendance = @participation.attendances.new(round: @tournament.first_round)
    authorize @attendance
    @attendance.save!
    redirect_to @tournament, notice: t(".notice")
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
  end
end
