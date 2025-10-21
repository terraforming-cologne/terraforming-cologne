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
    @round = @tournament.rounds.find_by(number: @tournament.current_round_number)
    @attendance = Current.user.attendances.joins(:participation).find_by(participation: {tournament: @tournament})
    if @round.present? && @attendance.present?
      @game = @attendance.games.joins(:round).find_by(round: @round)
      @seat = @attendance.seats.joins(:game).find_by(game: @game)
      @opponent_seats = @game.seats.excluding(@seat)
    end
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
end
