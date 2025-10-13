class AddCurrentRoundNumberToTournaments < ActiveRecord::Migration[8.0]
  def change
    add_column :tournaments, :current_round_number, :integer, null: true
  end
end
