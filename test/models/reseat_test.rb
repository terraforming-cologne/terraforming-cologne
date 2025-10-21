require "test_helper"

class ReseatTest < ActiveSupport::TestCase
  setup do
    @seat1 = seats(:one)
    @seat2 = seats(:two)
    @seat3 = seats(:three)
  end

  test "is invalid without from_seat_id" do
    reseat = Reseat.new
    reseat.assign_attributes(to_seat_id: @seat2.id)
    assert_not reseat.valid?
    assert_not_nil reseat.errors.where(:from_seat_id, :blank)
  end

  test "is invalid without to_seat_id" do
    reseat = Reseat.new
    reseat.assign_attributes(from_seat_id: @seat1.id)
    assert_not reseat.valid?
    assert_not_nil reseat.errors.where(:to_seat_id, :blank)
  end

  test "is invalid when from_seat_id and to_seat_id are the same" do
    reseat = Reseat.new
    reseat.assign_attributes(from_seat_id: @seat1.id, to_seat_id: @seat1.id)
    assert_not reseat.valid?
    assert_not_nil reseat.errors.where(:base, :same_seat)
  end

  test "is invalid when seats are in different rounds" do
    reseat = Reseat.new
    reseat.assign_attributes(from_seat_id: @seat1.id, to_seat_id: @seat3.id)
    assert_not reseat.valid?
    assert_not_nil reseat.errors.where(:base, :different_rounds)
  end

  test "swaps attendance_ids between two seats" do
    reseat = Reseat.new
    from_seat_id = @seat1.id
    to_seat_id = @seat2.id
    reseat.assign_attributes(from_seat_id: from_seat_id, to_seat_id: to_seat_id)
    assert reseat.valid?

    assert_equal @seat1.reload.attendance_id, from_seat_id
    assert_equal @seat2.reload.attendance_id, to_seat_id
    reseat.save
    assert_equal @seat1.reload.attendance_id, to_seat_id
    assert_equal @seat2.reload.attendance_id, from_seat_id
  end
end
