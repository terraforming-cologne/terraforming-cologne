class AddUniqueIndexToGameIdInResults < ActiveRecord::Migration[8.0]
  def change
    remove_index :results, :game_id
    add_index :results, :game_id, unique: true
  end
end
