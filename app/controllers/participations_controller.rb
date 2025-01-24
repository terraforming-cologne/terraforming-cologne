class ParticipationsController < ApplicationController
  allow_unauthorized_access

  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  def show
    authorize @participant
  end

  def new
    redirect_to :root, notice: t(".notice") and return if authenticated? && Current.user.participating?

    @participant = Current.user.participants.new
  end

  def create
    @participant = Current.user.participants.new(participant_params)
    if @participant.save
      redirect_to :profile, notice: t(".notice")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @participant
  end

  def update
    authorize @participant
    if @participant.update(participant_params)
      redirect_to :profile
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @participant
    @participant.destroy!
    redirect_to :profile, notice: t(".notice")
  end

  private

  def set_participant
    @participant = Current.user.participants.first!
  end

  def participant_params
    params.expect(participant: [:brings_basegame_english, :brings_basegame_german, :brings_prelude_english, :brings_prelude_german, :brings_hellas_and_elysium, :comment])
  end
end
