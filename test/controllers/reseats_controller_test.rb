require "test_helper"

class ReseatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tournament = tournaments(:one)
    @seat1 = seats(:one)
    @seat2 = seats(:two)
    @seat3 = seats(:three)
    sign_in :admin
  end

  test "should get new" do
    get new_tournament_reseat_url(@tournament)
    assert_response :success
    # assert_select "form[action=?]", tournament_reseats_path(@tournament)
  end

  # TODO: locale
  test "should swap seats and redirect with valid params" do
    from_seat_participation_id = @seat1.participation_id
    to_seat_participation_id = @seat2.participation_id

    post tournament_reseats_url(@tournament), params: {
      reseat: {from_seat_id: @seat1.id, to_seat_id: @seat2.id}
    }

    assert_redirected_to @tournament
    assert_equal from_seat_participation_id, @seat1.reload.participation_id
    assert_equal to_seat_participation_id, @seat2.reload.participation_id
  end

  # test "should re-render new with invalid params" do
  #   post tournament_reseats_url(@tournament), params: {
  #     reseat: {from_seat_id: @seat1.id, to_seat_id: @seat3.id}
  #   }
  #
  #   assert_response :unprocessable_content
  #   # assert_select "form[action=?]", tournament_reseats_path(@tournament)
  #
  #   # seats should remain unchanged
  #   assert_equal seats(:one).participation_id, @seat1.reload.participation_id
  #   assert_equal seats(:two).participation_id, @seat2.reload.participation_id
  # end
end
