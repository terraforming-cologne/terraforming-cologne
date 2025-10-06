class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.belongs_to :table, null: false, foreign_key: true
      t.belongs_to :round, null: false, foreign_key: true

      t.timestamps
    end
  end
end
