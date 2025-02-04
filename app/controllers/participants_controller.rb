class ParticipantsController < ApplicationController
  def index
    authorize Participant
    @participants = Participant.active.order(:created_at)
  end
end
