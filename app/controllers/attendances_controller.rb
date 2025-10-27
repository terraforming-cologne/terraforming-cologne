class AttendancesController < ApplicationController
  before_action :set_tournament

  def create
    @participation = @tournament.participations.find_by(user: Current.user)
    @round = @tournament.rounds.find_by(number: 1)
    @attendance = Attendance.new(participation: @participation, round: @round)
    authorize @attendance
    @attendance.save!
    redirect_to @tournament, notice: t(".notice")
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
  end
end
