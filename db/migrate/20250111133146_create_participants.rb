class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.boolean :brings_basegame, null: false, default: false
      t.boolean :brings_prelude, null: false, default: false
      t.boolean :brings_hellas_and_elysium, null: false, default: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
