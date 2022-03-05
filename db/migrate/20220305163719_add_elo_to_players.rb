class AddEloToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :elo, :integer, default: 1500, null: false
  end
end
