class Registration
  include ActiveModel::Model

  attr_accessor :user, :participant, :user_attributes, :participant_attributes

  def initialize(*)
    super
    self.user ||= User.new(user_attributes)
    self.participant ||= Participant.new(participant_attributes)
  end

  def save
    ApplicationRecord.transaction do
      self.user.save!
      self.participant.user = self.user
      self.participant.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  else
    true
  end
end
