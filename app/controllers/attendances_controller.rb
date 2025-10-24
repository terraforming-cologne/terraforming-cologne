class AttendancesController < ApplicationController
  before_action :set_participation

  def new
    # TODO: build_... ???
    @attendance = @participation.attendance || @participation.build_attendance
    authorize @attendance
    redirect_to @attendance.tournament, notice: t(".already_attending") if @participation.attendance.persisted?
  end

  def create
    # TODO: build_... ???
    @attendance = @participation.build_attendance
    authorize @attendance
    @attendance.save!
  end

  private

  def set_participation
    @participation = Participation.find(params.expect(:participation_id))
  end
end
