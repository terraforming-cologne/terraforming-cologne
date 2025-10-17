class AddUniqueIndexToSeatIdInScores < ActiveRecord::Migration[8.0]
  def change
    remove_index :scores, :seat_id
    add_index :scores, :seat_id, unique: true
  end
end
