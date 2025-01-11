require "application_system_test_case"

class ParticipantsTest < ApplicationSystemTestCase
  setup do
    @participant = participants(:one)
  end

  test "visiting the index" do
    visit participants_url
    assert_selector "h1", text: "Participants"
  end

  test "should create participant" do
    visit participants_url
    click_on "New participant"

    check "Brings basegame" if @participant.brings_basegame
    check "Brings hellas and elysium" if @participant.brings_hellas_and_elysium
    check "Brings prelude" if @participant.brings_prelude
    fill_in "User", with: @participant.user_id
    click_on "Create Participant"

    assert_text "Participant was successfully created"
    click_on "Back"
  end

  test "should update Participant" do
    visit participant_url(@participant)
    click_on "Edit this participant", match: :first

    check "Brings basegame" if @participant.brings_basegame
    check "Brings hellas and elysium" if @participant.brings_hellas_and_elysium
    check "Brings prelude" if @participant.brings_prelude
    fill_in "User", with: @participant.user_id
    click_on "Update Participant"

    assert_text "Participant was successfully updated"
    click_on "Back"
  end

  test "should destroy Participant" do
    visit participant_url(@participant)
    click_on "Destroy this participant", match: :first

    assert_text "Participant was successfully destroyed"
  end
end
