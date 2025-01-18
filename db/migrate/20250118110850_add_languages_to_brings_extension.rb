class AddLanguagesToBringsExtension < ActiveRecord::Migration[8.0]
  def change
    rename_column :participants, :brings_basegame, :brings_basegame_english
    rename_column :participants, :brings_prelude, :brings_prelude_english
    add_column :participants, :brings_basegame_german, :boolean, null: false, default: false
    add_column :participants, :brings_prelude_german, :boolean, null: false, default: false
  end
end
