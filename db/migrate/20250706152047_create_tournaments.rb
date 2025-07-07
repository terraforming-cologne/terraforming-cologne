class CreateTournaments < ActiveRecord::Migration[8.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.date :date, null: false, index: {unique: true}
      t.integer :max_participations, null: false, default: 0

      t.timestamps
    end
  end
end
