class Admin::ReseatsController < ApplicationController
  include TournamentScoped

  def new
    authorize Reseat
    @reseat = Reseat.new
  end

  def create
    authorize Reseat
    @reseat = Reseat.new(reseat_params)
    if @reseat.save
      redirect_to @tournament
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def reseat_params
    params.expect(reseat: [:from_seat_id, :to_seat_id])
  end
end
