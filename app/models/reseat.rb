class Reseat
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations

  attribute :from_seat_id, :integer
  attribute :to_seat_id, :integer

  validates :from_seat_id, presence: true
  validates :to_seat_id, presence: true
  validate :ensure_different_seats
  validate :ensure_same_round

  def save
    return false unless valid?

    ApplicationRecord.transaction do
      from_participation_id = from_seat.participation_id
      to_participation_id = to_seat.participation_id

      from_seat.update!(participation_id: to_participation_id)
      to_seat.update!(participation_id: from_participation_id)
    end
  end

  private

  def from_seat
    @from_seat ||= Seat.find(from_seat_id)
  end

  def to_seat
    @to_seat ||= Seat.find(to_seat_id)
  end

  def ensure_different_seats
    return unless from_seat_id && to_seat_id

    if from_seat_id == to_seat_id
      errors.add(:base, :same_seat)
    end
  end

  def ensure_same_round
    return unless from_seat_id && to_seat_id

    if from_seat.round != to_seat.round
      errors.add(:base, :different_rounds)
    end
  end
end
