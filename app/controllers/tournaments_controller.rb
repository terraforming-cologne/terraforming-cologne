class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update]

  def index
    authorize Tournament
    @next_tournament = Tournament.next
    @planned_tournaments = Tournament.where(date: (@next_tournament&.date&.next_day || Date.current)..)
    @previous_tournaments = Tournament.where(date: ..Date.yesterday)
  end

  def show
    authorize @tournament
    Current.tournament = @tournament
  end

  def new
    authorize Tournament
    @tournament = Tournament.new
  end

  def create
    authorize Tournament
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      redirect_to :tournaments, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament
    if @tournament.update(tournament_params)
      redirect_to :tournaments, notice: t(".notice")
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params.expect(:id))
  end

  def tournament_params
    params.expect(tournament: [:name, :date, :max_participations])
  end
end
