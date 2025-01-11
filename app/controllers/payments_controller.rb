class PaymentsController < ApplicationController
  def create
    authorize :payment
    @participant = Participant.find(params.expect(:participant_id))
    @participant.update!(paid: true)
    redirect_to participants_path
  end
end
