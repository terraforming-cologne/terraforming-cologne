class PaymentsController < ApplicationController
  def create
    authorize :payment
    @participation = Participation.find(params.expect(:participation_id))
    @participation.update!(paid: true)
    redirect_to :participations
  end
end
