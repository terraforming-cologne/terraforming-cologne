class ReseatsController < ApplicationController
  before_action :set_tournament

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

  def set_tournament
    @tournament = Tournament.find(params.expect(:tournament_id))
  end
end
