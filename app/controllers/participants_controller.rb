class ParticipantsController < ApplicationController
  def index
    authorize Participant
    @participants = Participant.all
  end
end
