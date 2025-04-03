require "csv"

class ParticipantsController < ApplicationController
  def index
    authorize Participant
    @participants = Participant.active.order(:created_at)
  end

  def export
    authorize Participant
    participants = Participant.all.map do |p|
      {
        name: p.user.name,
        email_address: p.user.email_address,
        language: p.user.locale,
        basegame_english: p.brings_basegame_english,
        basegame_german: p.brings_basegame_german,
        prelude_english: p.brings_prelude_english,
        prelude_german: p.brings_prelude_german,
        hellas: p.brings_hellas_and_elysium,
        comment: p.comment,
        paid: p.paid
      }
    end
    column_names = participants[0].keys
    s = CSV.generate do |csv|
      csv << column_names
      participants.each do |participant|
        csv << participant.values
      end
    end
    send_data s, filename: "participants.csv", type: "text/csv", disposition: "attachment"
  end
end
