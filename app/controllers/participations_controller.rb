class ParticipationsController < ApplicationController
  include TournamentScoped

  allow_unauthorized_access

  spam_protect only: :create

  before_action :set_participation, only: [:show, :edit, :update, :destroy]

  def index
    @participations = @tournament.participations.includes(:user)
  end

  def show
    authorize @participation
  end

  def new
    redirect_to :root, notice: t(".notice") and return if Tournament.planned? && authenticated? && Current.user.participating?(Tournament.next)

    @participation = Participation.new(tournament: @tournament, user: Current.user)
  end

  def create
    @participation = Participation.new(participation_params)
    if @participation.save
      redirect_to :profile, notice: t(".notice")
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @participation
  end

  def update
    authorize @participation
    if @participation.update(participation_params)
      redirect_to :profile, notice: t(".notice")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @participation
    @participation.destroy!
    redirect_to :profile, notice: t(".notice")
  end

  private

  def set_participation
    @participation = Participation.find(params.expect(:id))
  end

  def participation_params
    params.expect(participation: [:user_id, :tournament_id, :brings_basegame_english, :brings_basegame_german, :brings_prelude_english, :brings_prelude_german, :brings_hellas_and_elysium, :comment])
  end
end
