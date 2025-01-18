class ParticipantsController < ApplicationController
  def index
    authorize Participant
    @participants = Participant.active
  end
end
