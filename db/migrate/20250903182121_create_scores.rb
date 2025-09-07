class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.string :corporation, null: false
      t.integer :points, null: false
      t.integer :rank, null: false
      t.belongs_to :seat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
