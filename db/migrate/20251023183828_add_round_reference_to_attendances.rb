class AddRoundReferenceToAttendances < ActiveRecord::Migration[8.0]
  def change
    add_reference :attendances, :round, null: false, foreign_key: true
  end
end
