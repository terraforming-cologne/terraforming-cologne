class AddShowRankingToRounds < ActiveRecord::Migration[8.1]
  def change
    add_column :rounds, :show_ranking, :boolean, default: false
  end
end
