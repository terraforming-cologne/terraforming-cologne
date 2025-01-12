class ParticipantsController < ApplicationController
  allow_unauthorized_access only: [:new, :create]

  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  def index
    authorize Participant
    @participants = Participant.active
  end

  def show
    authorize @participant
  end

  def new
    redirect_to root_path and return if Current.user.participating?

    @participant = Current.user.participants.new
  end

  def create
    @participant = Current.user.participants.new(participant_params)
    if @participant.save
      redirect_to :profile
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
      redirect_to @participant
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @participant
    @participant.destroy!
    redirect_to @participant.user
  end

  private

  def set_participant
    @participant = Participant.find(params.expect(:id))
  end

  def participant_params
    params.expect(participant: [:brings_basegame, :brings_prelude, :brings_hellas_and_elysium])
  end
end
