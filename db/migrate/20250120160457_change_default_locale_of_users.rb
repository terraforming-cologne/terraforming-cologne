class ChangeDefaultLocaleOfUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :locale, from: "en", to: nil
  end
end
