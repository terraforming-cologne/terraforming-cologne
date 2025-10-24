class ChangeUniqueIndexToParticipationOnAttendances < ActiveRecord::Migration[8.0]
  def change
    remove_index :attendances, :participation_id, unique: true
    add_index :attendances, :participation_id
    add_index :attendances, [:participation_id, :round_id], unique: true
  end
end
