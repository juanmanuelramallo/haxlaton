class CreatePlayerStats < ActiveRecord::Migration[7.0]
  def change
    create_table :player_stats do |t|
      t.integer :goals
      t.integer :assists
      t.integer :own_goals
      t.references :match_player, foreign_key: true

      t.timestamps
    end

    add_column :matches, :winner_team_id, :integer
  end
end
